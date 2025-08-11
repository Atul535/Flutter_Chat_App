import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/domain/chat/entities/conversation_preview.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';

class ChatList extends StatelessWidget {
  final List<ConversationPreview> conversations;
  const ChatList({
    super.key,
    required this.conversations,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: AppPallete.tileColor,
            border: Border.all(color: AppPallete.greyColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            tileColor: AppPallete.tileColor,
            onTap: () {
              appRouter.goNamed(
                RouteNames.message,
                pathParameters: {
                  'senderId': conversation.currentUserId,
                  'receiverId': conversation.contactId,
                  // 'conversationId': conversation.conversationId,
                },
              );
            },
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: AppPallete.greyColor.withOpacity(0.5),
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
            title: Text(
              conversation.contactName,
              style: TextStyle(
                  color: AppPallete.whiteColor, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              conversation.lastMessage,
              style: TextStyle(color: AppPallete.whiteColor),
            ),
            trailing: Text(
              conversation.lastMessageTime,
              style: TextStyle(color: AppPallete.greyColor),
            ),
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
