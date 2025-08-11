import 'package:chat_app/domain/chat/entities/message_entity.dart';

class ChatModel extends MessageEntity {
  ChatModel({
    required super.id,
    required super.senderId,
    required super.conversationId,
    required super.content,
    required super.timestamp,
    required super.receiverId,
  });

  factory ChatModel.fromJson(Map<String, dynamic> map) {
    // safe parse of created_at
    final createdAtRaw =
        map['created_at'] ?? map['createdAt'] ?? map['timestamp'];
    DateTime parsedTimestamp;
    if (createdAtRaw is String) {
      parsedTimestamp = DateTime.tryParse(createdAtRaw) ?? DateTime.now();
    } else if (createdAtRaw is DateTime) {
      parsedTimestamp = createdAtRaw;
    } else {
      parsedTimestamp = DateTime.now();
    }

    return ChatModel(
      id: map['id']?.toString() ?? '',
      senderId: map['sender_id']?.toString() ?? '',
      conversationId: map['conversation_id']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      timestamp: parsedTimestamp,
      // messages table may not have receiver_id — use the field if present
      receiverId: map['receiver_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'sender_id': senderId,
      'conversation_id': conversationId,
      'content': content,
      'created_at': timestamp.toUtc().toIso8601String(),
    };

    // include receiver_id only if present (useful if your API expects it)
    if (receiverId.isNotEmpty) {
      json['receiver_id'] = receiverId;
    }

    return json;
  }
}
