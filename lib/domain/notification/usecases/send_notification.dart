import 'package:chat_app/domain/notification/repositories/notification_repository.dart';

class SendNotification {
  final NotificationRepository repository;
  SendNotification(this.repository);
  Future<void> call({required String userId,required String title,required String body}) async {
    try {
      await repository.sendNotification(
        userId:userId,
        title:title,
        body:body
      );
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }
}
