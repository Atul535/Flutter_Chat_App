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
        .from('messages2') // Changed to consistent name
        .stream(primaryKey: ['id'])
        .order('timestamp')
        .map((rows) => rows
            .map((e) => ChatModel.fromJson(e))
            .where((msg) =>
                (msg.senderId == senderId && msg.receiverId == receiverId) ||
                (msg.senderId == receiverId && msg.receiverId == senderId))
            .toList());
  }

  // @override
  // Future<void> sendMessage(ChatModel message) async {
  //   final user = supabaseClient.auth.currentUser;
  //   debugPrint('🔐 currentUser: $user');
  //   if (user == null) throw Exception('User not authenticated');
  //   if (message.senderId != user.id) throw Exception('Sender ID mismatch');

  //   final payload = {
  //     'id': message.id,
  //     'sender_id': message.senderId,
  //     'receiver_id': message.receiverId,
  //     'message': message.message,
  //     'timestamp': message.timestamp.toUtc().toIso8601String(),
  //   };

  //   debugPrint('→ Inserting payload: $payload');

  //   try {
  //     final response = await supabaseClient
  //         .from('messages2') // Changed to consistent name
  //         .insert(payload)
  //         .select();

  //     debugPrint('✅ Insert successful: $response');
  //   } on PostgrestException catch (e) {
  //     debugPrint('❌ Supabase error: ${e.message}');
  //     throw Exception('Insert failed: ${e.message}');
  //   } catch (e) {
  //     debugPrint('❌ Unexpected error: $e');
  //     rethrow;
  //   }
  // }

  @override
  Future<void> sendMessage(ChatModel message) async {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

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

    final res = await supabase.from('messages2').insert(payload);

    if (res.error != null) {
      debugPrint("❌ Supabase insert error: ${res.error!.message}");
      throw Exception('Insert failed: ${res.error!.message}');
    }

    debugPrint("✅ Message inserted successfully");
  }
}
