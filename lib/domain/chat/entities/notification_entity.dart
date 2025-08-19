class NotificationEntity {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String metadata;
  final bool isRead;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.metadata,
    required this.isRead,
    required this.createdAt,
  });
}

