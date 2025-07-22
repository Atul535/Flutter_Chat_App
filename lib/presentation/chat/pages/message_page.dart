import 'package:chat_app/presentation/chat/widgets/message_app_bar.dart';
import 'package:chat_app/presentation/chat/widgets/msg_input_box.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  final String senderId;
  final String receiverId;
  const MessagePage({
    super.key,
    required this.senderId,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MessageAppBar(),
        bottomNavigationBar: MsgInputBox(
          receiverId: receiverId,
          senderId: senderId,
        ),
      ),
    );
  }
}
