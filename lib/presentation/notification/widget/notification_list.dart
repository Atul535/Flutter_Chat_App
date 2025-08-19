import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/domain/chat/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationList extends StatefulWidget {
  final List<NotificationEntity> notifications;
  const NotificationList({
    super.key,
    required this.notifications,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
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
      return DateFormat.jm().format(dt);
    } else if (diff == 1) {
      return 'Yesterday';
    } else {
      return DateFormat.yMMMd().format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.notifications.length,
      itemBuilder: (context, index) {
        final notification = widget.notifications[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: AppPallete.tileColor,
            border: Border.all(color: AppPallete.greyColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            tileColor: AppPallete.tileColor,
            title: Text(
              notification.title,
              style: TextStyle(
                color: AppPallete.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              notification.body,
              style: TextStyle(color: AppPallete.whiteColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: Text(
              _formatTime(notification.createdAt),
              style: TextStyle(color: AppPallete.greyColor),
            ),
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
