import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Modelo de dados do usuário
class UserModel {
  final String uid;
  final String email;
  final String? nome;
  final String? telefone;
  final String? fotoUrl;
  final DateTime? dataNascimento;
  final String? genero;
  final DateTime? dataCriacao;

  UserModel({
    required this.uid,
    required this.email,
    this.nome,
    this.telefone,
    this.fotoUrl,
    this.dataNascimento,
    this.genero,
    this.dataCriacao,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      nome: data['nome'],
      telefone: data['telefone'],
      fotoUrl: data['fotoUrl'],
      dataNascimento: (data['dataNascimento'] as Timestamp?)?.toDate(),
      genero: data['genero'],
      dataCriacao: (data['dataCriacao'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'nome': nome,
      'telefone': telefone,
      'fotoUrl': fotoUrl,
      'dataNascimento': dataNascimento != null
          ? Timestamp.fromDate(dataNascimento!)
          : null,
      'genero': genero,
      'dataCriacao': dataCriacao ?? FieldValue.serverTimestamp(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? nome,
    String? telefone,
    String? fotoUrl,
    DateTime? dataNascimento,
    String? genero,
    DateTime? dataCriacao,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      genero: genero ?? this.genero,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }
}

/// Serviço de autenticação com Firebase
/// Gerencia login, signup, logout e deleção de conta
class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _error;

  // ===== Getters =====

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ===== Inicialização =====

  AuthService() {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) async {
    _user = user;
    if (user != null) {
      await _loadUserData();
    } else {
      _userModel = null;
    }
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    if (_user == null) return;

    try {
      final doc = await _firestore.collection('usuarios').doc(_user!.uid).get();
      if (doc.exists) {
        _userModel = UserModel.fromFirestore(doc);
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados do usuário: $e');
    }
  }

  // ===== Métodos de Autenticação =====

  /// Fazer login com email e senha
  Future<bool> signIn({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('Erro ao fazer login. Tente novamente.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Criar nova conta
  Future<bool> signUp({
    required String email,
    required String password,
    required String nome,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Cria usuário no Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Cria documento do usuário no Firestore
      if (credential.user != null) {
        // Atualiza o displayName no Authentication para consistência
        await credential.user!.updateDisplayName(nome.trim());

        final userModel = UserModel(
          uid: credential.user!.uid,
          email: email.trim(),
          nome: nome.trim(),
          dataCriacao: DateTime.now(),
        );

        await _firestore
            .collection('usuarios')
            .doc(credential.user!.uid)
            .set(userModel.toFirestore());

        _userModel = userModel;
        notifyListeners(); // Garante atualização da UI
      }

      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_getErrorMessage(e.code));
      return false;
    } catch (e) {
      _setError('Erro ao criar conta. Tente novamente.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Fazer logout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userModel = null;
    } catch (e) {
      debugPrint('Erro ao fazer logout: $e');
    }
  }

  /// Excluir conta permanentemente
  Future<bool> deleteAccount() async {
    if (_user == null) return false;

    _setLoading(true);
    _clearError();

    try {
      // Deleta documento do usuário no Firestore
      await _firestore.collection('usuarios').doc(_user!.uid).delete();

      // Deleta usuário do Firebase Auth
      await _user!.delete();

      _userModel = null;
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _setError(
          'Por segurança, faça login novamente antes de excluir sua conta.',
        );
      } else {
        _setError(_getErrorMessage(e.code));
      }
      return false;
    } catch (e) {
      _setError('Erro ao excluir conta. Tente novamente.');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Atualizar dados do perfil
  Future<bool> updateProfile({
    String? displayName,
    String? telefone,
    DateTime? dataNascimento,
    String? genero,
    String? fotoUrl,
  }) async {
    if (_user == null) return false;

    _setLoading(true);
    _clearError();

    try {
      if (displayName != null) {
        await _user!.updateDisplayName(displayName.trim());
      }
      if (fotoUrl != null) {
        await _user!.updatePhotoURL(fotoUrl);
      }

      final updates = <String, dynamic>{};
      if (displayName != null) updates['nome'] = displayName.trim();
      if (telefone != null) updates['telefone'] = telefone.trim();
      if (dataNascimento != null) {
        updates['dataNascimento'] = Timestamp.fromDate(dataNascimento);
      }
      if (genero != null) updates['genero'] = genero;
      if (fotoUrl != null) updates['fotoUrl'] = fotoUrl;

      if (updates.isNotEmpty) {
        await _firestore
            .collection('usuarios')
            .doc(_user!.uid)
            .set(updates, SetOptions(merge: true));
      }

      // Recarrega dados do usuário no Auth para garantir atualização de photoURL/displayName
      await _user!.reload();
      _user = _auth.currentUser;

      // Recarrega dados do Firestore
      await _loadUserData();
      notifyListeners();

      return true;
    } catch (e) {
      _setError('Erro ao atualizar perfil: $e');
      debugPrint('Erro no updateProfile: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Enviar email de redefinição de senha
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } catch (e) {
      debugPrint('Erro ao enviar email de reset: $e');
      return false;
    }
  }

  // ===== Helpers =====

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  /// Limpa erro manualmente
  void clearError() {
    _clearError();
    notifyListeners();
  }

  /// Traduz códigos de erro do Firebase para mensagens amigáveis
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Este email já está em uso.';
      case 'weak-password':
        return 'A senha deve ter pelo menos 6 caracteres.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde um momento.';
      case 'network-request-failed':
        return 'Erro de conexão. Verifique sua internet.';
      default:
        return 'Erro de autenticação. Tente novamente.';
    }
  }
}
