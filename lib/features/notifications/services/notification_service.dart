import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';
import '../../subscriptions/models/subscription_model.dart';

class NotificationService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache local para éviter disparos múltiplos na mesma sessão
  bool _dailyCheckPerformed = false;

  /// Stream de notificações do usuário, ordenadas por data descresente
  Stream<List<NotificationModel>> getNotifications(String userId) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  /// Conta notificações não lidas para o badge
  Stream<int> getUnreadCount(String userId) {
    if (userId.isEmpty) return Stream.value(0);

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Marca uma notificação como lida
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      debugPrint('Erro ao marcar notificação como lida: $e');
    }
  }

  /// Marca TODAS as notificações como lidas
  Future<void> markAllAsRead(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Erro ao marcar todas como lidas: $e');
    }
  }

  /// Remove uma notificação
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).delete();
    } catch (e) {
      debugPrint('Erro ao deletar notificação: $e');
    }
  }

  /// Cria uma notificação manualmente (uso interno)
  Future<void> _createNotification(NotificationModel notification) async {
    try {
      await _firestore.collection('notifications').add(notification.toMap());
    } catch (e) {
      debugPrint('Erro ao criar notificação: $e');
    }
  }

  // ===== LÓGICA DE TRIGGER AUTOMÁTICO =====

  /// Executa verificações diárias (Inscrições, Fixas, Dicas)
  Future<void> checkDailyNotifications(String userId) async {
    if (_dailyCheckPerformed || userId.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final lastCheckKey = 'last_notification_check_$userId';
    final lastCheckStr = prefs.getString(lastCheckKey);
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";

    // Se já rodou hoje, retorna
    if (lastCheckStr == todayStr) {
      _dailyCheckPerformed = true;
      return;
    }

    _dailyCheckPerformed = true;

    // Roda as verificações
    await _checkSubscriptions(userId);
    await _checkFixedTransactions(userId);
    await _checkFinancialTip(userId, prefs);

    // Salva que rodou hoje
    await prefs.setString(lastCheckKey, todayStr);
  }

  /// Verifica Inscrições vencendo em 1-2 dias
  Future<void> _checkSubscriptions(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('inscricoes')
          .where('userId', isEqualTo: userId)
          .where('ativo', isEqualTo: true)
          .get();

      final now = DateTime.now();

      for (var doc in snapshot.docs) {
        final sub = SubscriptionModel.fromFirestore(doc);

        // Simples verificação baseada no dia de cobrança no mês atual
        // Isso pode ser aprimorado para lidar com fim de mês (ex: dia 31)
        final dueDate = DateTime(now.year, now.month, sub.diaCobranca);
        final difference = dueDate.difference(now).inDays;

        // Se vence amanhã (0 a 1 dia de diferença dependendo da hora)
        if (difference >= 0 && difference <= 1) {
          // Verifica se já não notificamos sobre isso hoje/recentemente
          // Para simplificar, vamos confiar que 'checkDailyNotifications' protege o flood diário
          // mas idealmente verificaríamos se já existe notificação com esse relatedId criada recentemente

          await _createNotification(
            NotificationModel(
              id: '',
              userId: userId,
              title: 'Pagamento Próximo',
              body:
                  'Sua assinatura "${sub.nome}" vence dia ${sub.diaCobranca}. Valor: R\$ ${sub.valor.toStringAsFixed(2)}',
              type: NotificationType.reminder,
              createdAt: DateTime.now(),
              relatedId: sub.id,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Erro no checkSubscriptions: $e');
    }
  }

  /// Lembrete de Transações Fixas (Dia 1 e 15)
  Future<void> _checkFixedTransactions(String userId) async {
    final now = DateTime.now();

    // Apenas dia 1 ou dia 15
    if (now.day != 1 && now.day != 15) return;

    try {
      // Verifica se tem templates
      final snapshot = await _firestore
          .collection('fixed_transactions')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await _createNotification(
          NotificationModel(
            id: '',
            userId: userId,
            title: 'Lembrete de Fixas',
            body: now.day == 1
                ? 'Novo mês começando! Não esqueça de lançar suas despesas fixas.'
                : 'Meio do mês! Já lançou todas as suas contas fixas?',
            type: NotificationType.info,
            createdAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      debugPrint('Erro no checkFixedTransactions: $e');
    }
  }

  /// Dicas Financeiras (Dia sim, dia não)
  Future<void> _checkFinancialTip(
    String userId,
    SharedPreferences prefs,
  ) async {
    final lastTipKey = 'last_tip_date_$userId';
    final lastTipStr = prefs.getString(lastTipKey);
    final now = DateTime.now();

    // Se nunca enviou, ou enviou há mais de 1 dia (aprox 48h ou check simples de dia diferente e > 1 dia de diferença)
    bool shouldSend = false;

    if (lastTipStr == null) {
      shouldSend = true;
    } else {
      final lastDate = DateTime.parse(lastTipStr);
      final diff = now.difference(lastDate).inDays;
      if (diff >= 2) {
        // Dia sim, dia não (pelo menos 2 dias de intervalo)
        shouldSend = true;
      }
    }

    if (shouldSend) {
      final tip = _getRandomTip();
      await _createNotification(
        NotificationModel(
          id: '',
          userId: userId,
          title: 'Dica Financeira 💡',
          body: tip,
          type: NotificationType.tip,
          createdAt: DateTime.now(),
        ),
      );
      await prefs.setString(lastTipKey, now.toIso8601String());
    }
  }

  String _getRandomTip() {
    const tips = [
      "A regra 50-30-20 sugere: 50% para necessidades, 30% para desejos e 20% para poupança.",
      "Antes de comprar algo caro, espere 24 horas. Se a vontade passar, era impulso.",
      "Crie um fundo de emergência que cubra pelo menos 3 meses de suas despesas.",
      "Revise suas assinaturas mensalmente. Cancele o que não usa.",
      "Pagar à vista com desconto é quase sempre melhor que parcelar.",
      "Acompanhe seus gastos diariamente para não ter surpresas no fim do mês.",
      "Defina objetivos claros: saber PARA QUE você está economizando torna o processo mais fácil.",
      "Evite ir ao supermercado com fome, você acabará comprando mais do que precisa.",
      "Tente negociar suas dívidas ou tarifas bancárias anualmente.",
      "Invista em conhecimento: quanto mais você sabe, melhores decisões financeiras toma.",
    ];
    return tips[Random().nextInt(tips.length)];
  }
}
