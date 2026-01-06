import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../goals/models/goal_model.dart';
import '../../home/models/category_model.dart';
import '../../home/models/fixed_transaction_model.dart';
import '../../home/models/transaction_model.dart';

import '../../subscriptions/models/subscription_model.dart';

/// Serviço para operações no Firestore
/// Gerencia categorias, transações, objetivos e inscrições
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

  /// Stream de categorias genérico baseada no tipo
  Stream<List<CategoryModel>> getCategoriesStream(
    String userId,
    CategoryType type,
  ) {
    return type == CategoryType.expense
        ? getExpenseCategories(userId)
        : getIncomeCategories(userId);
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

  /// Stream de todas as transações de um ano específico (para Dashboard)
  Stream<List<TransactionModel>> getTransactionsByYear(
    String userId,
    int year,
  ) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('transacoes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .where((t) => t.data.year == year)
              .toList();
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

  // ===== OBJETIVOS =====

  /// Stream de objetivos do usuário
  Stream<List<GoalModel>> getGoals(String userId) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('objetivos')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          debugPrint(
            'Firestore: getGoals retornou ${snapshot.docs.length} documentos para userId=$userId',
          );
          final list = snapshot.docs
              .map((doc) => GoalModel.fromFirestore(doc))
              .toList();
          // Ordenar: não concluídos primeiro, depois por data de criação
          list.sort((a, b) {
            if (a.concluido != b.concluido) {
              return a.concluido ? 1 : -1;
            }
            return b.dataCriacao.compareTo(a.dataCriacao);
          });
          return list;
        });
  }

  /// Adiciona um novo objetivo
  Future<String?> addGoal(GoalModel goal) async {
    try {
      final docRef = await _firestore
          .collection('objetivos')
          .add(goal.toFirestore());
      debugPrint('Objetivo adicionado com ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Erro ao adicionar objetivo: $e');
      return null;
    }
  }

  /// Atualiza um objetivo existente
  Future<bool> updateGoal(GoalModel goal) async {
    if (goal.id == null) return false;

    try {
      await _firestore
          .collection('objetivos')
          .doc(goal.id)
          .update(goal.toFirestore());
      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar objetivo: $e');
      return false;
    }
  }

  /// Remove um objetivo
  Future<bool> deleteGoal(String goalId) async {
    try {
      await _firestore.collection('objetivos').doc(goalId).delete();
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar objetivo: $e');
      return false;
    }
  }

  // ===== INSCRIÇÕES =====

  /// Stream de inscrições do usuário
  Stream<List<SubscriptionModel>> getSubscriptions(String userId) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('inscricoes')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          debugPrint(
            'Firestore: getSubscriptions retornou ${snapshot.docs.length} documentos para userId=$userId',
          );
          final list = snapshot.docs
              .map((doc) => SubscriptionModel.fromFirestore(doc))
              .toList();
          // Ordenar: ativos primeiro, depois por nome
          list.sort((a, b) {
            if (a.ativo != b.ativo) {
              return a.ativo ? -1 : 1;
            }
            return a.nome.compareTo(b.nome);
          });
          return list;
        });
  }

  /// Adiciona uma nova inscrição
  Future<String?> addSubscription(SubscriptionModel subscription) async {
    try {
      final docRef = await _firestore
          .collection('inscricoes')
          .add(subscription.toFirestore());
      debugPrint('Inscrição adicionada com ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('Erro ao adicionar inscrição: $e');
      return null;
    }
  }

  /// Atualiza uma inscrição existente
  Future<bool> updateSubscription(SubscriptionModel subscription) async {
    if (subscription.id == null) return false;

    try {
      await _firestore
          .collection('inscricoes')
          .doc(subscription.id)
          .update(subscription.toFirestore());
      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar inscrição: $e');
      return false;
    }
  }

  /// Remove uma inscrição
  Future<bool> deleteSubscription(String subscriptionId) async {
    try {
      await _firestore.collection('inscricoes').doc(subscriptionId).delete();
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar inscrição: $e');
      return false;
    }
  }

  // ===== TRANSAÇÕES FIXAS (TEMPLATES) =====

  /// Stream de transações fixas (templates)
  Stream<List<FixedTransactionModel>> getFixedTransactions(
    String userId,
    TransactionType type,
  ) {
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('fixed_transactions')
        .where('userId', isEqualTo: userId)
        .where('tipo', isEqualTo: type.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return FixedTransactionModel.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  /// Adiciona uma nova transação fixa
  Future<String?> addFixedTransaction(FixedTransactionModel model) async {
    try {
      final docRef = await _firestore
          .collection('fixed_transactions')
          .add(model.toMap());
      return docRef.id;
    } catch (e) {
      debugPrint('Erro ao adicionar transação fixa: $e');
      return null;
    }
  }

  /// Remove uma transação fixa
  Future<void> deleteFixedTransaction(String id) async {
    try {
      await _firestore.collection('fixed_transactions').doc(id).delete();
    } catch (e) {
      debugPrint('Erro ao deletar transação fixa: $e');
    }
  }
}
