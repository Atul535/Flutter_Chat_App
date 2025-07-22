import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ChatRemoteDataSource {
  Stream<List<ChatModel>> getMessages({
    required String senderId,
    required String receiverId,
  });

  Future<void> sendMessage(ChatModel message);
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
        .from('messages2')
        .stream(primaryKey: ['id'])
        .order('timestamp')
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
      'timestamp': message.timestamp.toUtc().toIso8601String(),
    };

    debugPrint("📦 Sending message payload: $payload");

    final res = await supabaseClient.from('messages2').insert(payload);

    if (res.error != null) {
      debugPrint("❌ Supabase insert error: ${res.error!.message}");
      throw Exception('Insert failed: ${res.error!.message}');
    }

    debugPrint("✅ Message inserted successfully");
  }
}
