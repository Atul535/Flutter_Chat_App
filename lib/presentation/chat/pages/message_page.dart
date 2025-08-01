import 'package:chat_app/presentation/chat/widgets/message_app_bar.dart';
import 'package:chat_app/presentation/chat/widgets/msg_input_box.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessagePage extends StatelessWidget {
  final String senderId;
  final String receiverId;
  final String receiverName;

  const MessagePage({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
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
          stream: supabase
              .from('messages2')
              .stream(primaryKey: ['id']).order('timestamp'),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final messages = snapshot.data!;

            messages.sort((a, b) => DateTime.parse(a['timestamp'])
                .compareTo(DateTime.parse(b['timestamp'])));

            return ListView.builder(
              padding: const EdgeInsets.only(bottom: 80, top: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
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
                      msg['message'],
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
          senderId: senderId,
        ),
      ),
    );
  }
}
