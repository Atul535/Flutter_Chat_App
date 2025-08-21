import 'package:fpdart/fpdart.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/notification/entities/notification_entity.dart';
import 'package:chat_app/domain/notification/repositories/notification_repository.dart';
import 'package:chat_app/data/notifications/datasource/notification_remote_data_source_impl.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource notificationRemoteDataSource;
  NotificationRepositoryImpl(this.notificationRemoteDataSource);

  @override
  Future<Either<Failure, List<String>>> fetchNotifications({required String userId}) async {
    try {
      final ids = await notificationRemoteDataSource.fetchNotifications(userId: userId);
      return Right(ids);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<void> markNotificationAsRead({required String notificationId}) async {
    try {
      await notificationRemoteDataSource.markNotificationAsRead(notificationId: notificationId);
    } catch (e) {
      // keep exception type consistent (throw Exception) so callers can handle
      throw Exception('Mark notification as read failed: $e');
    }
  }

  @override
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      await notificationRemoteDataSource.sendNotification(
        userId: userId,
        title: title,
        body: body,
        metadata: '{}',
      );
    } catch (e) {
      throw Exception('Send notification failed: $e');
    }
  }

  @override
  Stream<List<NotificationEntity>> watchNotifications({required String userId}) {
    return notificationRemoteDataSource.watchNotifications(userId: userId);
  }
}
