import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:chat_app/domain/chat/entities/conversation_preview.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class ChatRemoteDataSource {
  Stream<List<ChatModel>> getMessages({
    required String conversationId,
  });

  Future<void> sendMessage({
    required ChatModel message,
    required String otherUserId,
  });

  Future<List<ConversationPreview>> getConversationPreviews();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;
  ChatRemoteDataSourceImpl(this.supabaseClient);

  Future<void> _ensureConversationExistsAndParticipants({
    required String conversationId,
    required String currentUserId,
    required String otherUserId,
  }) async {
    final supabase = supabaseClient;

    // 1) Ensure conversation exists (insert WITHOUT .select() to avoid RLS SELECT issues)
    final conv = await supabase
        .from('conversations')
        .select('id')
        .eq('id', conversationId)
        .maybeSingle();
    if (conv == null) {
      await supabase.from('conversations').insert({'id': conversationId});
    }

    // 2) Ensure current user is a participant (use user_id)
    final me = await supabase
        .from('conversation_participants')
        .select('id')
        .eq('conversation_id', conversationId)
        .eq('user_id', currentUserId)
        .maybeSingle();
    if (me == null) {
      await supabase
          .from('conversation_participants')
          .insert({
            'conversation_id': conversationId,
            'user_id': currentUserId,
            'added_by': currentUserId,
          })
          .select()
          .single();
    }

    // 3) Ensure the other participant exists, but determine whether it's a contact or an auth user.
    // First check contact table for that id:
    final contactRow = await supabase
        .from('contact')
        .select('id')
        .eq('id', otherUserId)
        .maybeSingle();

    if (contactRow != null) {
      // otherUserId is a contact id -> insert as contact_id
      final other = await supabase
          .from('conversation_participants')
          .select('id')
          .eq('conversation_id', conversationId)
          .eq('contact_id', otherUserId)
          .maybeSingle();
      if (other == null) {
        await supabase
            .from('conversation_participants')
            .insert({
              'conversation_id': conversationId,
              'contact_id': otherUserId,
              'added_by': currentUserId,
            })
            .select()
            .single();
      }
    } else {
      // otherUserId is probably an app user id — attempt to insert as user_id.
      final other = await supabase
          .from('conversation_participants')
          .select('id')
          .eq('conversation_id', conversationId)
          .eq('user_id', otherUserId)
          .maybeSingle();

      if (other == null) {
        try {
          await supabase
              .from('conversation_participants')
              .insert({
                'conversation_id': conversationId,
                'user_id': otherUserId,
                'added_by': currentUserId,
              })
              .select()
              .single();
        } catch (e, st) {
          debugPrint(
              '⚠️ Failed to insert other participant as user_id: $e\n$st');

          // Defensive fallback: maybe otherUserId is neither an auth user nor a contact.
          // You can either throw (preferred) or optionally try to insert as contact_id.
          // Here we attempt to insert as contact_id if contact table has a row (double-check)
          final contactRetry = await supabase
              .from('contact')
              .select('id')
              .eq('id', otherUserId)
              .maybeSingle();
          if (contactRetry != null) {
            // if contact exists now, insert as contact_id
            await supabase
                .from('conversation_participants')
                .insert({
                  'conversation_id': conversationId,
                  'contact_id': otherUserId,
                  'added_by': currentUserId,
                })
                .select()
                .single();
          } else {
            // Nothing to do — fail early with informative error
            throw Exception(
                'Failed to add other participant. $otherUserId is not an auth user and not a contact.');
          }
        }
      }
    }
  }

  @override
  Stream<List<ChatModel>> getMessages({
    required String conversationId,
  }) {
    return supabaseClient
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .map((rows) => rows.map((e) => ChatModel.fromJson(e)).toList());
  }

  @override
  Future<void> sendMessage({
    required ChatModel message,
    required String otherUserId,
  }) async {
    final currentUser = supabaseClient.auth.currentUser;

    if (currentUser == null) {
      throw Exception("User not authenticated");
    }
    if (message.senderId != currentUser.id) {
      throw Exception("Message sender does not match current user");
    }

    final convId = message.conversationId;

    await _ensureConversationExistsAndParticipants(
      conversationId: convId,
      currentUserId: currentUser.id,
      otherUserId: otherUserId,
    );

    final payload = {
      'id': message.id,
      'sender_id': message.senderId,
      'conversation_id': convId,
      'content': message.content,
      'created_at': message.timestamp.toUtc().toIso8601String(),
    };

    debugPrint("📦 Sending message payload: $payload");

    try {
      final inserted = await supabaseClient
          .from('messages')
          .insert(payload)
          .select()
          .single();

      debugPrint(
          "🟢 Modern insert returned (type: ${inserted.runtimeType}): $inserted");
      return;
    } catch (e) {
      debugPrint("⚠️ insert(...).select().single() failed: $e");
      rethrow;
    }
  }

  @override
  Future<List<ConversationPreview>> getConversationPreviews() async {
    final currentUser = supabaseClient.auth.currentUser;
    if (currentUser == null) throw Exception("User not authenticated");

    final response = await supabaseClient
        .from('conversation_previews2')
        .select()
        .order('last_message_time', ascending: false);

    return (response as List)
        .map((e) => ConversationPreview(
              conversationId: e['conversation_id'] ?? '',
              receiverId:
                  e['receiver_id']?.toString() ?? '', // Convert to string
              receiverName: e['receiver_name'] ?? '',
              receiverEmail: e['receiver_email'] ?? '',
              lastMessage: e['last_message'] ?? '',
              lastMessageTime: e['last_message_time'] ?? '',
              avatarUrl: e['receiver_avatar'] ?? '',
              currentUserId: currentUser.id,
            ))
        .toList();
  }
}
