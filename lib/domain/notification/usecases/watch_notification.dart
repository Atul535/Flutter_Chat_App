import 'package:chat_app/domain/notification/entities/notification_entity.dart';
import 'package:chat_app/domain/notification/repositories/notification_repository.dart';

class WatchNotification {
  final NotificationRepository repo;
  WatchNotification(this.repo);
  Stream<List<NotificationEntity>> call({required String userId}) {
    return repo.watchNotifications(userId: userId);
  }
}
