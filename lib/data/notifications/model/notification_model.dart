import 'package:chat_app/domain/chat/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String metadata;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.metadata,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      metadata: map['metadata'] ?? '',
      isRead: map['is_read'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'body': body,
        'metadata': metadata,
        'is_read': isRead,
        'created_at': createdAt.toIso8601String(),
      };

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      userId: userId,
      title: title,
      body: body,
      metadata: metadata,
      isRead: isRead,
      createdAt: createdAt,
    );
  }
}
