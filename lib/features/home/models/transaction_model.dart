import 'package:cloud_firestore/cloud_firestore.dart';

/// Tipo de transação
enum TransactionType { income, expense }

/// Modelo de transação (receita ou despesa)
class TransactionModel {
  final String? id;
  final String userId;
  final String categoryId;
  final String categoryName;
  final double valor;
  final String? descricao;
  final TransactionType tipo;
  final DateTime data;
  final DateTime? dataCriacao;

  TransactionModel({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.valor,
    this.descricao,
    required this.tipo,
    required this.data,
    this.dataCriacao,
  });

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'] ?? '',
      valor: (data['valor'] ?? 0).toDouble(),
      descricao: data['descricao'],
      tipo: data['tipo'] == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      data: (data['data'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dataCriacao: (data['dataCriacao'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'valor': valor,
      'descricao': descricao,
      'tipo': tipo == TransactionType.income ? 'income' : 'expense',
      'data': Timestamp.fromDate(data),
      'dataCriacao': dataCriacao ?? FieldValue.serverTimestamp(),
    };
  }

  /// Retorna true se for uma receita
  bool get isIncome => tipo == TransactionType.income;

  /// Retorna true se for uma despesa
  bool get isExpense => tipo == TransactionType.expense;
}
