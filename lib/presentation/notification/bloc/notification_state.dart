part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

/// Initial state (before anything starts)
final class NotificationInitial extends NotificationState {}

/// Loading state (when fetching / subscribing)
final class NotificationLoading extends NotificationState {}

/// Loaded state (notifications available)
final class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  NotificationLoaded(this.notifications);
}

/// Error state
final class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
