import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/notification/entities/notification_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class NotificationRepository {
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  });

  Stream<List<NotificationEntity>> watchNotifications({
    required String userId,
  });

  Future<Either<Failure, List<String>>> fetchNotifications({
    required String userId,
  });

  Future<void> markNotificationAsRead({
    required String notificationId,
  });
}