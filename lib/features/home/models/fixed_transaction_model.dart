import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart'; // Para TransactionType

class FixedTransactionModel {
  final String? id;
  final String userId;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final double valor;
  final String? descricao;
  final TransactionType tipo;

  FixedTransactionModel({
    this.id,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.valor,
    this.descricao,
    required this.tipo,
  });

  bool get isIncome => tipo == TransactionType.income;
  bool get isExpense => tipo == TransactionType.expense;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'valor': valor,
      'descricao': descricao,
      'tipo': tipo.name, // 'income' ou 'expense'
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory FixedTransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return FixedTransactionModel(
      id: id,
      userId: map['userId'] ?? '',
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      categoryIcon: map['categoryIcon'] ?? '',
      valor: (map['valor'] as num?)?.toDouble() ?? 0.0,
      descricao: map['descricao'],
      tipo: TransactionType.values.firstWhere(
        (e) => e.name == map['tipo'],
        orElse: () => TransactionType.expense,
      ),
    );
  }
}
