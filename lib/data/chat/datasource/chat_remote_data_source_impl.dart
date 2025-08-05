import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:chat_app/domain/chat/entities/conversation_preview.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ChatRemoteDataSource {
  Stream<List<ChatModel>> getMessages({
    required String senderId,
    required String receiverId,
  });

  Future<void> sendMessage(ChatModel message);

  Future<List<ConversationPreview>> getConversationPreviews();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;
  ChatRemoteDataSourceImpl(this.supabaseClient);

  @override
  Stream<List<ChatModel>> getMessages({
    required String senderId,
    required String receiverId,
  }) {
    return supabaseClient
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map((rows) => rows
            .map((e) => ChatModel.fromJson(e))
            .where((msg) =>
                (msg.senderId == senderId && msg.receiverId == receiverId) ||
                (msg.senderId == receiverId && msg.receiverId == senderId))
            .toList());
  }

  @override
  Future<void> sendMessage(ChatModel message) async {
    final currentUser = supabaseClient.auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not authenticated");
    }

    final payload = {
      'id': message.id,
      'sender_id': currentUser.id,
      'receiver_id': message.receiverId,
      'message': message.message,
      'created_at': message.timestamp.toUtc().toIso8601String(),
    };

    debugPrint("📦 Sending message payload: $payload");

    final res = await supabaseClient.from('messages').insert(payload);

    if (res.error != null) {
      debugPrint("❌ Supabase insert error: ${res.error!.message}");
      throw Exception('Insert failed: ${res.error!.message}');
    }

    debugPrint("✅ Message inserted successfully");
  }

  @override
  Future<List<ConversationPreview>> getConversationPreviews() async {
    final currentUser = supabaseClient.auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not authenticated");
    }
    final response =
        await supabaseClient.from('conversation_previews').select();

    return (response as List)
        .map((e) => ConversationPreview(
              contactId: e['contact_id'] ?? '',
              contactName: e['contact_name'] ?? '',
              contactEmail: e['contact_email'] ?? '',
              lastMessage: e['last_message'] ?? '',
              lastMessageTime: e['last_message_time'] ?? '',
              avatarUrl: e['avatar_url'] ?? '',
              currentUserId: currentUser.id,
            ))
        .toList();
  }
}
