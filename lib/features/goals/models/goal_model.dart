import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de Objetivo (meta financeira)
class GoalModel {
  final String? id;
  final String userId;
  final String? environmentId;
  final String nome;
  final String icone;
  final double valorAlvo;
  final double valorAtual;
  final DateTime dataLimite;
  final DateTime dataCriacao;
  final bool concluido;

  GoalModel({
    this.id,
    required this.userId,
    this.environmentId,
    required this.nome,
    required this.icone,
    required this.valorAlvo,
    this.valorAtual = 0,
    required this.dataLimite,
    DateTime? dataCriacao,
    this.concluido = false,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  /// Progresso em porcentagem (0.0 a 1.0)
  double get progresso {
    if (valorAlvo <= 0) return 0;
    return (valorAtual / valorAlvo).clamp(0.0, 1.0);
  }

  /// Progresso em porcentagem formatado
  int get progressoPorcentagem => (progresso * 100).round();

  /// Valor restante para atingir a meta
  double get valorRestante => (valorAlvo - valorAtual).clamp(0.0, valorAlvo);

  /// Dias restantes até a data limite
  int get diasRestantes {
    final hoje = DateTime.now();
    return dataLimite.difference(hoje).inDays;
  }

  /// Verifica se está atrasado
  bool get atrasado => diasRestantes < 0 && !concluido;

  /// Cria a partir de um documento Firestore
  factory GoalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GoalModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      environmentId: data['environmentId'],
      nome: data['nome'] ?? '',
      icone: data['icone'] ?? 'savings',
      valorAlvo: (data['valorAlvo'] ?? 0).toDouble(),
      valorAtual: (data['valorAtual'] ?? 0).toDouble(),
      dataLimite:
          (data['dataLimite'] as Timestamp?)?.toDate() ?? DateTime.now(),
      dataCriacao:
          (data['dataCriacao'] as Timestamp?)?.toDate() ?? DateTime.now(),
      concluido: data['concluido'] ?? false,
    );
  }

  /// Converte para formato Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'environmentId': environmentId,
      'nome': nome,
      'icone': icone,
      'valorAlvo': valorAlvo,
      'valorAtual': valorAtual,
      'dataLimite': Timestamp.fromDate(dataLimite),
      'dataCriacao': Timestamp.fromDate(dataCriacao),
      'concluido': concluido,
    };
  }

  /// Cria uma cópia com valores atualizados
  GoalModel copyWith({
    String? id,
    String? userId,
    String? environmentId,
    String? nome,
    String? icone,
    double? valorAlvo,
    double? valorAtual,
    DateTime? dataLimite,
    DateTime? dataCriacao,
    bool? concluido,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      environmentId: environmentId ?? this.environmentId,
      nome: nome ?? this.nome,
      icone: icone ?? this.icone,
      valorAlvo: valorAlvo ?? this.valorAlvo,
      valorAtual: valorAtual ?? this.valorAtual,
      dataLimite: dataLimite ?? this.dataLimite,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      concluido: concluido ?? this.concluido,
    );
  }
}
