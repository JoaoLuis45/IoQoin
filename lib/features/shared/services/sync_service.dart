import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../environments/models/environment_model.dart';

class SyncService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lista de subscriptions para limpar depois
  final List<StreamSubscription> _subscriptions = [];

  // Estado
  bool _hasChanges = false;
  bool get hasChanges => _hasChanges;

  // IDs para controle de duplicação
  String? _currentEnvironmentId;
  DateTime? _lastSyncTime;

  /// Inicia o monitoramento do ambiente
  void initialize(EnvironmentModel environment, String currentUserId) {
    if (_currentEnvironmentId == environment.id && _subscriptions.isNotEmpty) {
      return;
    }

    _disposeSubscriptions();
    _currentEnvironmentId = environment.id;
    _lastSyncTime = DateTime.now();
    _hasChanges = false;
    notifyListeners();

    if (environment.id == null) return;

    // Monitorar coleções principais independentemente
    _monitorCollection('transacoes', environment.id!);
    _monitorCollection('categorias', environment.id!);
    _monitorCollection('metas', environment.id!);
    _monitorCollection('inscricoes', environment.id!);
    _monitorCollection('fixed_transactions', environment.id!);

    // SE for compartilhado, monitorar o nome no documento do dono e atualizar localmente se mudar
    if (environment.isShared && environment.ownerId != null) {
      _monitorSharedEnvironmentMetadata(environment, currentUserId);
    }
  }

  void _monitorSharedEnvironmentMetadata(
    EnvironmentModel currentEnv,
    String currentUserId,
  ) {
    if (currentEnv.id == null || currentEnv.ownerId == null) return;

    // Escuta o documento original do ambiente lá no usuário dono
    final sub = _firestore
        .collection('usuarios')
        .doc(currentEnv.ownerId)
        .collection('environments')
        .doc(currentEnv.id)
        .snapshots()
        .listen((snapshot) async {
          if (snapshot.exists) {
            final data = snapshot.data();
            if (data != null) {
              final remoteName = data['name'] as String?;
              if (remoteName != null &&
                  remoteName.isNotEmpty &&
                  remoteName != currentEnv.name) {
                // Se o nome mudou, atualiza a cópia local do usuário compartilhado
                debugPrint(
                  'SyncService: Nome do ambiente mudou de "${currentEnv.name}" para "$remoteName". Atualizando...',
                );

                try {
                  await _firestore
                      .collection('usuarios')
                      .doc(currentUserId)
                      .collection('environments')
                      .doc(currentEnv.id)
                      .update({'name': remoteName});

                  // O listener do EnvironmentService vai pegar essa mudança local e atualizar a UI
                } catch (e) {
                  debugPrint(
                    'SyncService: Erro ao atualizar nome do ambiente: $e',
                  );
                }
              }
            }
          }
        });

    _subscriptions.add(sub);
  }

  void _monitorCollection(String collectionPath, String environmentId) {
    final sub = _firestore
        .collection(collectionPath)
        .where('environmentId', isEqualTo: environmentId)
        .snapshots()
        .listen(
          (snapshot) => _handleSnapshot(snapshot),
          onError: (error) {
            debugPrint('SyncService Error for $collectionPath: $error');
            // Não bloqueia/crasha, apenas loga.
          },
        );

    _subscriptions.add(sub);
  }

  void _handleSnapshot(QuerySnapshot snapshot) {
    // Verifica se há mudanças reais de documentos
    bool hasModifications = false;

    for (var _ in snapshot.docChanges) {
      if (!snapshot.metadata.hasPendingWrites) {
        hasModifications = true;
        break;
      }
    }

    if (hasModifications) {
      // Se a mudança ocorreu após o inicio do monitoramento (margem de segurança)
      if (_lastSyncTime != null &&
          DateTime.now().difference(_lastSyncTime!) >
              const Duration(seconds: 2)) {
        _hasChanges = true;
        notifyListeners();
      }
    }
  }

  /// Limpa o status de mudanças (ao recarregar)
  void clearChanges() {
    _hasChanges = false;
    _lastSyncTime = DateTime.now();
    notifyListeners();
  }

  /// Força um refresh simbólico
  Future<void> reload() async {
    clearChanges();
    // Em streams isso é automático, mas notificamos para atualizar UI se necessário
    notifyListeners();
  }

  void _disposeSubscriptions() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }

  @override
  void dispose() {
    _disposeSubscriptions();
    super.dispose();
  }
}
