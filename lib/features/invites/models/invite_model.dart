import 'package:cloud_firestore/cloud_firestore.dart';

enum InviteStatus { pending, accepted, rejected }

class InviteModel {
  final String id;
  final String fromUserId;
  final String fromUserName;
  final String toUserTag;
  final String
  toUserId; // Adicionado para regras de segurança e queries robustas
  final String environmentId;
  final String environmentName;
  final InviteStatus status;
  final DateTime createdAt;

  InviteModel({
    required this.id,
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserTag,
    required this.toUserId,
    required this.environmentId,
    required this.environmentName,
    required this.status,
    required this.createdAt,
  });

  factory InviteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InviteModel(
      id: doc.id,
      fromUserId: data['fromUserId'] ?? '',
      fromUserName: data['fromUserName'] ?? '',
      toUserTag: data['toUserTag'] ?? '',
      toUserId: data['toUserId'] ?? '',
      environmentId: data['environmentId'] ?? '',
      environmentName: data['environmentName'] ?? '',
      status: InviteStatus.values.firstWhere(
        (e) => e.name == (data['status'] ?? 'pending'),
        orElse: () => InviteStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fromUserId': fromUserId,
      'fromUserName': fromUserName,
      'toUserTag': toUserTag,
      'toUserId': toUserId,
      'environmentId': environmentId,
      'environmentName': environmentName,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
