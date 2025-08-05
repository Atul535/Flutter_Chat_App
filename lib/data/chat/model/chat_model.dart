import 'package:chat_app/domain/chat/entities/message_entity.dart';

class ChatModel extends MessageEntity {
  ChatModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.message,
    required super.timestamp,
  });

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.parse(map['created_at'] ?? ''),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'created_at': timestamp.toUtc().toIso8601String(),
    };
  }
}
