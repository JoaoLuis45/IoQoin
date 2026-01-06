import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../home/models/category_model.dart';
import '../../home/models/transaction_model.dart';

/// Serviço para operações no Firestore
/// Gerencia categorias e transações (receitas/despesas)
class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ===== CATEGORIAS =====

  /// Stream de categorias de despesas do usuário
  /// Ordenação local para evitar necessidade de índice composto
  Stream<List<CategoryModel>> getExpenseCategories(String userId) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('categorias')
        .where('userId', isEqualTo: userId)
        .where('tipo', isEqualTo: 'expense')
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => CategoryModel.fromFirestore(doc))
              .toList();
          // Ordenação local
          list.sort((a, b) => a.nome.compareTo(b.nome));
          return list;
        });
  }

  /// Stream de categorias de receitas do usuário
  Stream<List<CategoryModel>> getIncomeCategories(String userId) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('categorias')
        .where('userId', isEqualTo: userId)
        .where('tipo', isEqualTo: 'income')
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => CategoryModel.fromFirestore(doc))
              .toList();
          list.sort((a, b) => a.nome.compareTo(b.nome));
          return list;
        });
  }

  /// Adiciona uma nova categoria
  Future<String?> addCategory(CategoryModel category) async {
    try {
      final docRef = await _firestore
          .collection('categorias')
          .add(category.toFirestore());
      debugPrint('Categoria adicionada com ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Erro ao adicionar categoria: $e');
      return null;
    }
  }

  /// Atualiza uma categoria existente
  Future<bool> updateCategory(CategoryModel category) async {
    if (category.id == null) return false;

    try {
      await _firestore.collection('categorias').doc(category.id).update({
        'nome': category.nome,
        'icone': category.icone,
      });
      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar categoria: $e');
      return false;
    }
  }

  /// Remove uma categoria
  Future<bool> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categorias').doc(categoryId).delete();
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar categoria: $e');
      return false;
    }
  }

  /// Verifica se o usuário tem categorias de um tipo específico
  Future<bool> hasCategories(String userId, CategoryType type) async {
    if (userId.isEmpty) return false;

    try {
      final snapshot = await _firestore
          .collection('categorias')
          .where('userId', isEqualTo: userId)
          .where(
            'tipo',
            isEqualTo: type == CategoryType.income ? 'income' : 'expense',
          )
          .limit(1)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Erro ao verificar categorias: $e');
      return false;
    }
  }

  // ===== TRANSAÇÕES =====

  /// Stream de despesas do usuário (filtrado por mês/ano)
  Stream<List<TransactionModel>> getExpenses(
    String userId, {
    int? month,
    int? year,
  }) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('transacoes')
        .where('userId', isEqualTo: userId)
        .where('tipo', isEqualTo: 'expense')
        .snapshots()
        .map((snapshot) {
          var list = snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList();

          // Filtrar por mês/ano se especificado
          if (month != null && year != null) {
            list = list
                .where((t) => t.data.month == month && t.data.year == year)
                .toList();
          }

          list.sort((a, b) => b.data.compareTo(a.data));
          return list;
        });
  }

  /// Stream de receitas do usuário (filtrado por mês/ano)
  Stream<List<TransactionModel>> getIncomes(
    String userId, {
    int? month,
    int? year,
  }) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('transacoes')
        .where('userId', isEqualTo: userId)
        .where('tipo', isEqualTo: 'income')
        .snapshots()
        .map((snapshot) {
          var list = snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList();

          // Filtrar por mês/ano se especificado
          if (month != null && year != null) {
            list = list
                .where((t) => t.data.month == month && t.data.year == year)
                .toList();
          }

          list.sort((a, b) => b.data.compareTo(a.data));
          return list;
        });
  }

  /// Adiciona uma nova transação
  Future<String?> addTransaction(TransactionModel transaction) async {
    try {
      final docRef = await _firestore
          .collection('transacoes')
          .add(transaction.toFirestore());
      return docRef.id;
    } catch (e) {
      debugPrint('Erro ao adicionar transação: $e');
      return null;
    }
  }

  /// Remove uma transação
  Future<bool> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('transacoes').doc(transactionId).delete();
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar transação: $e');
      return false;
    }
  }

  /// Calcula o total de despesas do mês atual
  Future<double> getMonthlyExpenseTotal(String userId) async {
    if (userId.isEmpty) return 0;

    try {
      // Busca todas as despesas e filtra localmente pelo mês
      final snapshot = await _firestore
          .collection('transacoes')
          .where('userId', isEqualTo: userId)
          .where('tipo', isEqualTo: 'expense')
          .get();

      final now = DateTime.now();
      double total = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final transactionDate = (data['data'] as Timestamp?)?.toDate();
        if (transactionDate != null &&
            transactionDate.year == now.year &&
            transactionDate.month == now.month) {
          total += (data['valor'] ?? 0).toDouble();
        }
      }
      return total;
    } catch (e) {
      debugPrint('Erro ao calcular total de despesas: $e');
      return 0;
    }
  }

  /// Calcula o total de receitas do mês atual
  Future<double> getMonthlyIncomeTotal(String userId) async {
    if (userId.isEmpty) return 0;

    try {
      final snapshot = await _firestore
          .collection('transacoes')
          .where('userId', isEqualTo: userId)
          .where('tipo', isEqualTo: 'income')
          .get();

      final now = DateTime.now();
      double total = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final transactionDate = (data['data'] as Timestamp?)?.toDate();
        if (transactionDate != null &&
            transactionDate.year == now.year &&
            transactionDate.month == now.month) {
          total += (data['valor'] ?? 0).toDouble();
        }
      }
      return total;
    } catch (e) {
      debugPrint('Erro ao calcular total de receitas: $e');
      return 0;
    }
  }

  /// Stream de total de despesas (atualiza em tempo real, filtrado por mês/ano)
  Stream<double> watchMonthlyExpenseTotal(
    String userId, {
    int? month,
    int? year,
  }) {
    if (userId.isEmpty) return Stream.value(0);

    final targetMonth = month ?? DateTime.now().month;
    final targetYear = year ?? DateTime.now().year;

    return _firestore
        .collection('transacoes')
        .where('userId', isEqualTo: userId)
        .where('tipo', isEqualTo: 'expense')
        .snapshots()
        .map((snapshot) {
          double total = 0;

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final transactionDate = (data['data'] as Timestamp?)?.toDate();
            if (transactionDate != null &&
                transactionDate.year == targetYear &&
                transactionDate.month == targetMonth) {
              total += (data['valor'] ?? 0).toDouble();
            }
          }
          return total;
        });
  }

  /// Stream de total de receitas (atualiza em tempo real, filtrado por mês/ano)
  Stream<double> watchMonthlyIncomeTotal(
    String userId, {
    int? month,
    int? year,
  }) {
    if (userId.isEmpty) return Stream.value(0);

    final targetMonth = month ?? DateTime.now().month;
    final targetYear = year ?? DateTime.now().year;

    return _firestore
        .collection('transacoes')
        .where('userId', isEqualTo: userId)
        .where('tipo', isEqualTo: 'income')
        .snapshots()
        .map((snapshot) {
          double total = 0;

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final transactionDate = (data['data'] as Timestamp?)?.toDate();
            if (transactionDate != null &&
                transactionDate.year == targetYear &&
                transactionDate.month == targetMonth) {
              total += (data['valor'] ?? 0).toDouble();
            }
          }
          return total;
        });
  }
}
