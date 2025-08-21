import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/notification/repositories/notification_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchNotification {
  final NotificationRepository repo;
  FetchNotification(this.repo);

  Future<Either<Failure, List<String>>> call({required String userId}) async {
    return repo.fetchNotifications(userId: userId);
  }
}
