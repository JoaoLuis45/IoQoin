import 'package:cloud_firestore/cloud_firestore.dart';

/// Frequência de cobrança da inscrição
enum SubscriptionFrequency {
  weekly,
  monthly,
  yearly;

  String get label {
    switch (this) {
      case SubscriptionFrequency.weekly:
        return 'Semanal';
      case SubscriptionFrequency.monthly:
        return 'Mensal';
      case SubscriptionFrequency.yearly:
        return 'Anual';
    }
  }

  String get firebaseValue {
    switch (this) {
      case SubscriptionFrequency.weekly:
        return 'weekly';
      case SubscriptionFrequency.monthly:
        return 'monthly';
      case SubscriptionFrequency.yearly:
        return 'yearly';
    }
  }

  static SubscriptionFrequency fromString(String value) {
    switch (value) {
      case 'weekly':
        return SubscriptionFrequency.weekly;
      case 'yearly':
        return SubscriptionFrequency.yearly;
      default:
        return SubscriptionFrequency.monthly;
    }
  }
}

/// Modelo de Inscrição (assinatura recorrente)
class SubscriptionModel {
  final String? id;
  final String userId;
  final String nome;
  final String icone;
  final double valor;
  final SubscriptionFrequency frequencia;
  final int diaCobranca; // Dia do mês (1-31)
  final DateTime dataCriacao;
  final bool ativo;

  SubscriptionModel({
    this.id,
    required this.userId,
    required this.nome,
    required this.icone,
    required this.valor,
    this.frequencia = SubscriptionFrequency.monthly,
    required this.diaCobranca,
    DateTime? dataCriacao,
    this.ativo = true,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  /// Valor mensal equivalente
  double get valorMensal {
    switch (frequencia) {
      case SubscriptionFrequency.weekly:
        return valor * 4.33; // ~4.33 semanas por mês
      case SubscriptionFrequency.monthly:
        return valor;
      case SubscriptionFrequency.yearly:
        return valor / 12;
    }
  }

  /// Próxima data de cobrança
  DateTime get proximaCobranca {
    final hoje = DateTime.now();
    var proxima = DateTime(hoje.year, hoje.month, diaCobranca.clamp(1, 28));

    if (proxima.isBefore(hoje) || proxima.isAtSameMomentAs(hoje)) {
      proxima = DateTime(hoje.year, hoje.month + 1, diaCobranca.clamp(1, 28));
    }

    return proxima;
  }

  /// Dias até a próxima cobrança
  int get diasAteCobranca {
    return proximaCobranca.difference(DateTime.now()).inDays;
  }

  /// Cria a partir de um documento Firestore
  factory SubscriptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubscriptionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      nome: data['nome'] ?? '',
      icone: data['icone'] ?? 'subscriptions',
      valor: (data['valor'] ?? 0).toDouble(),
      frequencia: SubscriptionFrequency.fromString(
        data['frequencia'] ?? 'monthly',
      ),
      diaCobranca: data['diaCobranca'] ?? 1,
      dataCriacao:
          (data['dataCriacao'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ativo: data['ativo'] ?? true,
    );
  }

  /// Converte para formato Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'nome': nome,
      'icone': icone,
      'valor': valor,
      'frequencia': frequencia.firebaseValue,
      'diaCobranca': diaCobranca,
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      'ativo': ativo,
    };
  }

  /// Cria uma cópia com valores atualizados
  SubscriptionModel copyWith({
    String? id,
    String? userId,
    String? nome,
    String? icone,
    double? valor,
    SubscriptionFrequency? frequencia,
    int? diaCobranca,
    DateTime? dataCriacao,
    bool? ativo,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nome: nome ?? this.nome,
      icone: icone ?? this.icone,
      valor: valor ?? this.valor,
      frequencia: frequencia ?? this.frequencia,
      diaCobranca: diaCobranca ?? this.diaCobranca,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      ativo: ativo ?? this.ativo,
    );
  }
}
