import 'package:cloud_firestore/cloud_firestore.dart';

class EnvironmentModel {
  final String? id;
  final String userId; // Owner (or pointer holder)
  final String name;
  final int iconCodePoint; // Armazenamos o codePoint do IconData
  final String colorHex; // Armazenamos a cor como Hex String
  final DateTime createdAt;
  final bool isDefault; // Se é o ambiente padrão (pessoal)
  final bool isShared; // Se é um ambiente compartilhado
  final String? ownerId; // ID do dono original (se isShared == true)

  EnvironmentModel({
    this.id,
    required this.userId,
    required this.name,
    required this.iconCodePoint,
    required this.colorHex,
    required this.createdAt,
    this.isDefault = false,
    this.isShared = false,
    this.ownerId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'colorHex': colorHex,
      'createdAt': Timestamp.fromDate(createdAt),
      'isDefault': isDefault,
      'isShared': isShared,
      'ownerId': ownerId,
    };
  }

  factory EnvironmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EnvironmentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? 'Ambiente',
      iconCodePoint: data['iconCodePoint'] ?? 58136, // Icons.home default
      colorHex: data['colorHex'] ?? 'FF00F5D4', // Volt Cyan default
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isDefault: data['isDefault'] ?? false,
      isShared: data['isShared'] ?? false,
      ownerId: data['ownerId'],
    );
  }

  EnvironmentModel copyWith({
    String? id,
    String? userId,
    String? name,
    int? iconCodePoint,
    String? colorHex,
    DateTime? createdAt,
    bool? isDefault,
    bool? isShared,
    String? ownerId,
  }) {
    return EnvironmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
      isDefault: isDefault ?? this.isDefault,
      isShared: isShared ?? this.isShared,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
