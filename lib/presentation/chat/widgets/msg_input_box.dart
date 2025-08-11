import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/data/chat/model/chat_model.dart';
import 'package:chat_app/presentation/chat/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

String generateConversationId(String userA, String userB) {
  final sorted = [userA, userB]..sort();
  final combined = '${sorted[0]}:${sorted[1]}';
  return _uuid.v5(Uuid.NAMESPACE_URL, combined);
}

class MsgInputBox extends StatefulWidget {
  final String receiverId;
  // final String conversationId;

  const MsgInputBox({
    super.key,
    required this.receiverId,
    // required this.conversationId,
  });

  @override
  State<MsgInputBox> createState() => _MsgInputBoxState();
}

class _MsgInputBoxState extends State<MsgInputBox> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;

  void _sendMessage() {
    final text = _controller.text.trim();
    debugPrint("🔍 _sendMessage called with text: '$text'");

    if (text.isEmpty) {
      debugPrint("⚠️ Text is empty, returning early");
      return;
    }

    final currentUser = supabase.auth.currentUser;
    debugPrint("🔍 Current user: ${currentUser?.id}");

    if (currentUser == null) {
      debugPrint("❌ No current user");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be signed in to send messages')),
      );
      return;
    }

    final convId = generateConversationId(currentUser.id, widget.receiverId);
    debugPrint("🔍 Generated conversation ID: $convId");

    final message = ChatModel(
      id: const Uuid().v4(),
      senderId: currentUser.id,
      conversationId: convId,
      content: text,
      timestamp: DateTime.now(),
      receiverId: widget.receiverId,
    );

    debugPrint("🔍 Created message: ${message.toJson()}");
    debugPrint("🔍 About to dispatch SendMessageEvent");

    context.read<ChatBloc>().add(SendMessageEvent(
          content: message,
          otherUserId: widget.receiverId,
        ));

    debugPrint("🔍 SendMessageEvent dispatched, clearing text field");
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
              icon: const Icon(Icons.camera_alt, size: 28),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: const Icon(Icons.attach_file, size: 28),
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  fillColor: AppPallete.backgroundColor2,
                  filled: true,
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: _sendMessage,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: AppPallete.gradient4,
                child: const Icon(Icons.send_rounded,
                    size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
