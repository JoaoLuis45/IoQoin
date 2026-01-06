enum NotificationType {
  alert, // Algo critico (vermelho)
  reminder, // Lembrete (azul/amarelo)
  success, // Conquista (verde)
  info, // Informativo (cinza)
  tip, // Dica financeira (roxo/gradiente)
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? relatedId; // ID de uma inscrição, meta, etc.

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.relatedId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'relatedId': relatedId,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.info,
      ),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
      relatedId: map['relatedId'],
    );
  }
}
