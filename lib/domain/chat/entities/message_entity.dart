class MessageEntity {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });
}
