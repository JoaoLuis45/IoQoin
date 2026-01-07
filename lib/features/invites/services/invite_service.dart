import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/invite_model.dart';
import '../../environments/models/environment_model.dart';

class InviteService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Envia um convite para um usuário via Tag
  Future<String?> sendInvite({
    required String fromUserId,
    required String fromUserName,
    required String toUserTag,
    required EnvironmentModel environment,
  }) async {
    if (toUserTag.isEmpty || environment.id == null) return 'Dados inválidos';

    // Não pode convidar a si mesmo (verificação básica, mas a UI deve impedir também)
    // Teria que buscar meu próprio userTag para saber, mas deixamos para UI

    _isLoading = true;
    notifyListeners();

    try {
      // 1. Verifica se a Tag existe
      final userQuery = await _firestore
          .collection('usuarios')
          .where('userTag', isEqualTo: toUserTag)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        return 'Usuário com a tag $toUserTag não encontrado.';
      }

      final userDoc = userQuery.docs.first;
      final targetUserId = userDoc.id;
      debugPrint(
        'InviteService: Usuário encontrado para tag $toUserTag: ID=$targetUserId',
      );

      // 1.5 Verifica se o usuário JÁ participa do ambiente
      final alreadyMemberCheck = await _firestore
          .collection('usuarios')
          .doc(targetUserId)
          .collection('environments')
          .doc(environment.id)
          .get();

      if (alreadyMemberCheck.exists) {
        return 'Este usuário já participa deste ambiente.';
      }

      /*
      // 2. Verifica se já existe convite pendente ou aceito para este ambiente/usuário
      final existingInvite = await _firestore
          .collection('invites')
          .where('toUserId', isEqualTo: targetUserId)
          .where(
            'fromUserId',
            isEqualTo: fromUserId,
          ) // Necessário para passar na regra de segurança
          .where('environmentId', isEqualTo: environment.id)
          .where('status', isEqualTo: 'pending')
          .limit(1)
          .get();

      if (existingInvite.docs.isNotEmpty) {
        debugPrint('InviteService: Já existe convite pendente.');
        return 'Já existe um convite pendente para este usuário.';
      }
      */

      // 3. Cria o convite
      final invite = InviteModel(
        id: '', // Firestore gera
        fromUserId: fromUserId,
        fromUserName: fromUserName,
        toUserTag: toUserTag,
        toUserId: targetUserId,
        environmentId: environment.id!,
        environmentName: environment.name,
        status: InviteStatus.pending,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('invites').add(invite.toFirestore());
      debugPrint(
        'InviteService: Convite enviado com sucesso para $targetUserId.',
      );

      return null; // Sucesso
    } catch (e) {
      debugPrint('InviteService: Erro ao enviar convite: $e');
      return 'Erro ao enviar convite: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Stream de convites pendentes para o usuário atual
  Stream<List<InviteModel>> watchMyInvites(String myUserId) {
    if (myUserId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('invites')
        .where('toUserId', isEqualTo: myUserId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => InviteModel.fromFirestore(doc))
              .toList();
        });
  }

  /// Aceita um convite
  /// Isso cria uma cópia "espelho" do ambiente collection dentro do usuário convidado
  Future<bool> acceptInvite(InviteModel invite, String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Atualiza status do convite
      await _firestore.collection('invites').doc(invite.id).update({
        'status': 'accepted',
      });

      // 2. Cria o ambiente "espelho" no perfil do usuário convidado
      // CRUCIAL: O ID do documento deve ser o mesmo do environmentId original
      final sharedEnvData = {
        'name': invite.environmentName,
        'iconCodePoint': 58536, // Ícone padrão de "Pessoas" ou similar
        'colorHex': '0xFF2196F3', // Azul padrão para compartilhados
        'createdAt': FieldValue.serverTimestamp(),
        'isDefault': false,
        'userId': userId, // O "dono" desse registro de ponteiro é o convidado
        'isShared': true,
        'ownerId': invite.fromUserId, // Dono original dos dados
      };

      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('environments')
          .doc(invite.environmentId) // MESMO ID DO AMBIENTE ORIGINAL
          .set(sharedEnvData);

      return true;
    } catch (e) {
      debugPrint('Erro ao aceitar convite: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Rejeita um convite
  Future<bool> rejectInvite(String inviteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firestore.collection('invites').doc(inviteId).update({
        'status': 'rejected',
      });
      return true;
    } catch (e) {
      debugPrint('Erro ao rejeitar convite: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sai de um ambiente compartilhado (remove o atalho do perfil do usuário)
  Future<bool> leaveSharedEnvironment(
    String environmentId,
    String userId,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Deleta o documento "ponteiro" na coleção de environments do usuário
      await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('environments')
          .doc(environmentId)
          .delete();

      debugPrint(
        'Saiu do ambiente $environmentId com sucesso (ponteiro removido).',
      );
      return true;
    } catch (e) {
      debugPrint('Erro ao sair do ambiente: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
