// lib/presentation/notification/widget/notification_list.dart
import 'dart:convert';

import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/domain/notification/entities/notification_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final void Function(String notificationId) onMarkRead;
  final void Function(NotificationEntity notification, Map<String, dynamic> metadata)? onNavigate;

  const NotificationList({
    super.key,
    required this.notifications,
    required this.onMarkRead,
    this.onNavigate,
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
      return DateFormat.jm().format(dt);
    } else if (diff == 1) {
      return 'Yesterday';
    } else {
      return DateFormat.yMMMd().format(dt);
    }
  }

  Map<String, dynamic> _parseMetadata(dynamic metadata) {
    // metadata may come as json string or Map
    if (metadata == null) return {};
    if (metadata is Map<String, dynamic>) return metadata;
    if (metadata is String) {
      try {
        final decoded = jsonDecode(metadata);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {}
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Center(
        child: Text(
          'No notifications yet',
          style: TextStyle(fontSize: 18, color: AppPallete.greyColor),
        ),
      );
    }

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        final meta = _parseMetadata(notification.metadata);
        final isRead = notification.isRead;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: AppPallete.tileColor,
            border: Border.all(color: AppPallete.greyColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            tileColor: AppPallete.tileColor,
            leading: isRead
                ? null
                : Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent,
                    ),
                  ),
            title: Text(
              notification.title,
              style: TextStyle(
                color: AppPallete.whiteColor,
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
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
            onTap: () {
              // mark as read if unread
              if (!notification.isRead) {
                onMarkRead(notification.id);
              }
              // navigate if caller provided handler and metadata contains navigation info
              if (onNavigate != null) onNavigate!(notification, meta);
            },
            onLongPress: () {
              // optional: show details or actions
              showModalBottomSheet(
                context: context,
                backgroundColor: AppPallete.backgroundColor,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(notification.body),
                      const SizedBox(height: 8),
                      Text('Received: ${_formatTime(notification.createdAt)}', style: TextStyle(color: AppPallete.greyColor)),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
