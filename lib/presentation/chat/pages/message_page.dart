import 'package:chat_app/presentation/chat/widgets/message_app_bar.dart';
import 'package:chat_app/presentation/chat/widgets/msg_input_box.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MessageAppBar(),
        bottomNavigationBar: MsgInputBox(),
      ),
    );
  }
}
