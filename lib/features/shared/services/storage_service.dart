import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Faz upload da imagem de perfil do usuário e retorna a URL de download.
  /// Salva em: profile_images/{userId}/avatar.jpg
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      // Cria referência no caminho do usuário
      // Usamos sempre 'avatar.jpg' para sobrescrever a anterior e economizar espaço,
      // mas o navegador pode cachear. Para evitar cache, poderíamos usar avatar_{timestamp}.jpg
      // Mas o Firebase Storage lida bem com isso se pegarmos downloadURL novo.
      // Para garantir atualização visual, adicionaremos timestamp na URL ou usaremos UniqueKey na UI.
      final ref = _storage.ref().child('profile_images/$userId/avatar.jpg');

      // Upload
      final uploadTask = ref.putFile(imageFile);

      // Aguarda completar
      await uploadTask;

      // Retorna URL
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('Erro ao fazer upload da imagem: $e');
      throw Exception('Falha ao enviar imagem: $e');
    }
  }
}
