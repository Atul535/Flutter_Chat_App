// lib/presentation/notification/bloc/notification_event.dart
import 'package:chat_app/domain/notification/entities/notification_entity.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NotificationEvent {
  const NotificationEvent();
}

/// Start watching notifications for a given userId
class StartWatchingNotifications extends NotificationEvent {
  final String userId;
  const StartWatchingNotifications({required this.userId});
}

/// Stop watching (cancels subscription)
class StopWatchingNotifications extends NotificationEvent {
  const StopWatchingNotifications();
}

/// Internal event: new list arrived from repository
class NotificationsUpdated extends NotificationEvent {
  final List<NotificationEntity> notifications;
  const NotificationsUpdated(this.notifications);
}

/// Mark notification read
class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;
  const MarkNotificationAsRead(this.notificationId);
}

/// Send a notification (optional)
class SendNotificationEvent extends NotificationEvent {
  final String userId;
  final String title;
  final String body;
  const SendNotificationEvent({
    required this.userId,
    required this.title,
    required this.body,
  });
}
