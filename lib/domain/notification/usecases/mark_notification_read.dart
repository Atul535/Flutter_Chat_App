import 'package:chat_app/domain/notification/repositories/notification_repository.dart';

class MarkNotificationRead {
  final NotificationRepository repo;
  MarkNotificationRead(this.repo);

  Future<void> call({required String notificationId}) {
    return repo.markNotificationAsRead(notificationId: notificationId);
  }
}