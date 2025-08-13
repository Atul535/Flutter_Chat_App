import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/domain/chat/entities/conversation_preview.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatList extends StatelessWidget {
  final List<ConversationPreview> conversations;
  const ChatList({
    super.key,
    required this.conversations,
  });

  DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    try {
      if (date is DateTime) return date.toLocal();
      if (date is int) {
        return DateTime.fromMillisecondsSinceEpoch(date).toLocal();
      }
      if (date is String) return DateTime.parse(date).toLocal();
    } catch (_) {}
    return null;
  }

  String _formatTime(dynamic date) {
    final dt = _parseDate(date);
    if (dt == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(messageDay).inDays;

    if (diff == 0) {
      return DateFormat.jm().format(dt); // today -> time
    } else if (diff == 1) {
      return 'Yesterday';
    } else {
      return DateFormat.yMMMd().format(dt); // older -> date
    }
  }

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
                },
                extra: conversation.conversationId,
              );
            },
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: AppPallete.greyColor.withOpacity(0.5),
              child: const Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
            title: Text(
              conversation.contactName,
              style: TextStyle(
                color: AppPallete.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              conversation.lastMessage,
              style: TextStyle(color: AppPallete.whiteColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: Text(
              _formatTime(conversation.lastMessageTime),
              style: TextStyle(color: AppPallete.greyColor),
            ),
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
