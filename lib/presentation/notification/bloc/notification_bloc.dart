import 'dart:async';
import 'package:chat_app/domain/notification/entities/notification_entity.dart';
import 'package:chat_app/domain/notification/repositories/notification_repository.dart';
import 'package:chat_app/domain/notification/usecases/send_notification.dart';
import 'package:chat_app/domain/notification/usecases/watch_notification.dart';
import 'package:chat_app/presentation/notification/bloc/notification_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final SendNotification sendNotification;
  final WatchNotification watchNotification;
  final NotificationRepository repository;
  StreamSubscription<List<NotificationEntity>>? _subscription;

  NotificationBloc(
    this.sendNotification,
    this.watchNotification,
    this.repository,
  ) : super(NotificationInitial()) {
    on<StartWatchingNotifications>((event, emit) async {
      emit(NotificationLoading());
      debugPrint('Subscribing to notifications...');
      await _subscription?.cancel();
      _subscription =
          repository.watchNotifications(userId: event.userId).listen(
        (notifications) {
          debugPrint('New notifications received: ${notifications.length}');
          add(NotificationsUpdated(notifications));
        },
        onError: (error) {
           debugPrint('Stream error: $error');
          emit(NotificationError(error.toString()));
        },
      );
    });

    on<StopWatchingNotifications>((event, emit) async {
      await _subscription?.cancel();
      _subscription = null;
      emit(NotificationInitial());
    });

    on<NotificationsUpdated>((event, emit) {
      debugPrint('Emitting NotificationLoaded with ${event.notifications.length} notifications');
      emit(NotificationLoaded(event.notifications));
    });

    // Mark as read
    on<MarkNotificationAsRead>((event, emit) async {
      try {
        await repository.markNotificationAsRead(
            notificationId: event.notificationId);
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    // Send a notification
    on<SendNotificationEvent>((event, emit) async {
      try {
        await sendNotification.call(
          userId: event.userId,
          title: event.title,
          body: event.body,
        );
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
