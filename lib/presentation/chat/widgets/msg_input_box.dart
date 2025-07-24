import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:chat_app/presentation/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class MsgInputBox extends StatefulWidget {
  final String receiverId;
  final String senderId;
  const MsgInputBox({
    super.key,
    required this.receiverId,
    required this.senderId,
  });

  @override
  State<MsgInputBox> createState() => _MsgInputBoxState();
}

class _MsgInputBoxState extends State<MsgInputBox> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // Get current authenticated user
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to send messages')),
      );
      return;
    }

    print('Sender ID: ${currentUser.id}, '
        'Receiver ID: ${currentUser.id}, '
        'Message: $text');

    final message = ChatModel(
      id: const Uuid().v4(),
      senderId: currentUser.id, // Use real user ID
      receiverId: currentUser.id,
      message: text,
      timestamp: DateTime.now(),
    );

    context.read<ChatBloc>().add(SendMessageEvent(message: message));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      color: AppPallete.appBarColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.camera_alt,
                  size: 28,
                )),
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.attach_file,
                  size: 28,
                )),
            TextField(
              controller: _controller,
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                  fillColor: AppPallete.backgroundColor2,
                  filled: true,
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15)),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: _sendMessage,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: AppPallete.gradient4,
                child: Icon(
                  Icons.send_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
