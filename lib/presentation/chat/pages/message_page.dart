import 'package:chat_app/core/utils/loader.dart';
import 'package:chat_app/presentation/chat/widgets/message_app_bar.dart';
import 'package:chat_app/presentation/chat/widgets/msg_input_box.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagePage extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String conversationId;

  const MessagePage({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    return SafeArea(
      child: Scaffold(
        appBar: MessageAppBar(
          name: receiverName,
          status: 'online',
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: supabase.from('messages').stream(primaryKey: ['id'])
              .eq('conversation_id', conversationId)
              .order('created_at'),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Loader());
            }

            final messages = snapshot.data!;
            final reversedMessages = messages.reversed.toList();

            // messages.sort((a, b) {
            //   DateTime ta, tb;
            //   try {
            //     ta = DateTime.parse(a['created_at']?.toString() ?? '');
            //   } catch (_) {
            //     ta = DateTime.fromMillisecondsSinceEpoch(0);
            //   }
            //   try {
            //     tb = DateTime.parse(b['created_at']?.toString() ?? '');
            //   } catch (_) {
            //     tb = DateTime.fromMillisecondsSinceEpoch(0);
            //   }
            //   return ta.compareTo(tb);
            // });

            return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 80, top: 10),
              itemCount: reversedMessages.length,
              itemBuilder: (context, index) {
                final msg = reversedMessages[index];
                final isMe = msg['sender_id'] == senderId;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      (msg['content'] ?? msg['message'] ?? '').toString(),
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: MsgInputBox(
          receiverId: receiverId,
          conversationId: conversationId,
        ),
      ),
    );
  }
}
