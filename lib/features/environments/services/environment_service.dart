import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/services/firestore_service.dart';
import '../models/environment_model.dart';
// Note: FirestoreService import added to call migration logic

class EnvironmentService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Estado atual
  EnvironmentModel? _currentEnvironment;
  EnvironmentModel? get currentEnvironment => _currentEnvironment;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Define o ambiente atual e notifica listeners
  Future<void> setEnvironment(EnvironmentModel env) async {
    _currentEnvironment = env;
    notifyListeners();

    // Persistindo a escolha
    if (env.id != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_env_id', env.id!);
    }
  }

  /// Limpa o ambiente atual (logout)
  Future<void> clearEnvironment() async {
    _currentEnvironment = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_env_id');
  }

  /// Inicializa o serviço carregando o ambiente do usuário
  Future<void> initialize(String userId) async {
    if (userId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('environments')
          .orderBy('createdAt')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final envs = snapshot.docs
            .map((d) => EnvironmentModel.fromFirestore(d))
            .toList();

        // Tenta recuperar o último ambiente usado
        final prefs = await SharedPreferences.getInstance();
        final lastEnvId = prefs.getString('last_env_id');

        EnvironmentModel? targetEnv;

        // Se tiver ID salvo, tenta achar na lista
        if (lastEnvId != null) {
          try {
            targetEnv = envs.firstWhere((e) => e.id == lastEnvId);
          } catch (_) {
            // Se não achar (foi deletado por ex), ignora e segue pro default
          }
        }

        // Se não achou pelo ID salvo, pega o default
        targetEnv ??= envs.firstWhere(
          (e) => e.isDefault,
          orElse: () => envs.first,
        );

        _currentEnvironment = targetEnv;

        // FIX: Migrar ícone se for o antigo (Icons.person -> Icons.home)
        if (_currentEnvironment != null &&
            _currentEnvironment!.isDefault &&
            _currentEnvironment!.iconCodePoint == 58536) {
          final updated = _currentEnvironment!.copyWith(iconCodePoint: 58136);
          await updateEnvironment(updated);
          _currentEnvironment = updated;
        }
      } else {
        // Se não existir nenhum, cria um padrão "Pessoal"
        // Icon code point 58136 = Icons.home
        await createEnvironment(
          userId: userId,
          name: 'Pessoal',
          iconCodePoint: 58136,
          colorHex: '0xFF4CAF50', // Green
          isDefault: true,
        );
        // createEnvironment já define _currentEnvironment
      }

      // DISPARAR MIGRAÇÃO DE DADOS LEGADOS
      if (_currentEnvironment != null && _currentEnvironment!.id != null) {
        // Instancia FirestoreService para rodar a migração
        await FirestoreService().migrateLegacyData(
          userId,
          _currentEnvironment!.id!,
        );
      }
    } catch (e) {
      debugPrint('Erro ao inicializar ambientes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ===== CRUD =====

  /// Retorna stream de ambientes do usuário
  Stream<List<EnvironmentModel>> getUserEnvironments(String userId) {
    return _firestore
        .collection('usuarios')
        .doc(userId)
        .collection('environments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => EnvironmentModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Cria um novo ambiente
  Future<EnvironmentModel?> createEnvironment({
    required String userId,
    required String name,
    required int iconCodePoint,
    required String colorHex,
    bool isDefault = false,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final newEnv = EnvironmentModel(
        userId: userId,
        name: name,
        iconCodePoint: iconCodePoint,
        colorHex: colorHex,
        createdAt: DateTime.now(),
        isDefault: isDefault,
      );

      final docRef = await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('environments')
          .add(newEnv.toFirestore());

      final createdEnv = EnvironmentModel(
        id: docRef.id,
        userId: userId,
        name: name,
        iconCodePoint: iconCodePoint,
        colorHex: colorHex,
        createdAt: newEnv.createdAt,
        isDefault: isDefault,
      );

      // Atualiza o estado local se foi criado com sucesso
      if (isDefault || _currentEnvironment == null) {
        _currentEnvironment = createdEnv;
      }

      return createdEnv;
    } catch (e) {
      debugPrint('Erro ao criar ambiente: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Atualiza ambiente existente
  Future<bool> updateEnvironment(EnvironmentModel env) async {
    if (env.id == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection('usuarios')
          .doc(env.userId)
          .collection('environments')
          .doc(env.id)
          .update(env.toFirestore());

      // Se atualizou o ambiente atual, reflete a mudança
      if (_currentEnvironment?.id == env.id) {
        _currentEnvironment = env;
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar ambiente: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Exclui um ambiente (Caution: This should verify if it has data first or move data)
  /// Por simplificação, não deleta dados em cascata ainda, o usuário deve deletar manualmente ou
  /// implementaremos um cloud function para limpeza.
  Future<bool> deleteEnvironment(String userId, String envId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('environments')
          .doc(envId)
          .delete();

      if (_currentEnvironment?.id == envId) {
        _currentEnvironment = null;
      }

      return true;
    } catch (e) {
      debugPrint('Erro ao deletar ambiente: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
