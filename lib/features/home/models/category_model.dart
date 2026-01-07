import 'package:cloud_firestore/cloud_firestore.dart';

/// Tipo de categoria: receita ou despesa
enum CategoryType { income, expense }

/// Modelo de categoria para receitas e despesas
class CategoryModel {
  final String? id;
  final String userId;
  final String? environmentId;
  final String nome;
  final String icone;
  final CategoryType tipo;
  final DateTime? dataCriacao;

  CategoryModel({
    this.id,
    required this.userId,
    this.environmentId,
    required this.nome,
    required this.icone,
    required this.tipo,
    this.dataCriacao,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      environmentId: data['environmentId'],
      nome: data['nome'] ?? '',
      icone: data['icone'] ?? 'category',
      tipo: data['tipo'] == 'income'
          ? CategoryType.income
          : CategoryType.expense,
      dataCriacao: (data['dataCriacao'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'environmentId': environmentId,
      'nome': nome,
      'icone': icone,
      'tipo': tipo == CategoryType.income ? 'income' : 'expense',
      'dataCriacao': dataCriacao ?? FieldValue.serverTimestamp(),
    };
  }

  CategoryModel copyWith({
    String? id,
    String? userId,
    String? environmentId,
    String? nome,
    String? icone,
    CategoryType? tipo,
    DateTime? dataCriacao,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      environmentId: environmentId ?? this.environmentId,
      nome: nome ?? this.nome,
      icone: icone ?? this.icone,
      tipo: tipo ?? this.tipo,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }
}
