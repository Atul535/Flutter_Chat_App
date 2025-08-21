import 'dart:async';

import 'package:chat_app/data/notifications/model/notification_model.dart';
import 'package:chat_app/domain/notification/entities/notification_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class NotificationRemoteDataSource {
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    String? metadata,
  });

  Stream<List<NotificationEntity>> watchNotifications({
    required String userId,
  });

  Future<List<String>> fetchNotifications({
    required String userId,
  });

  Future<void> markNotificationAsRead({
    required String notificationId,
  });

  Future<int> fetchUnreadCount({required String userId});
}

class NotificationRemoteDataSourceImpl extends NotificationRemoteDataSource {
  final SupabaseClient supabaseClient;
  NotificationRemoteDataSourceImpl(this.supabaseClient);
  final supabase = Supabase.instance.client;
  @override
  Future<List<String>> fetchNotifications({required String userId}) async {
    try {
      final res = await supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(100);
      final data = res as List<dynamic>? ?? [];
      return data.map((e) => e['id'].toString()).toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  @override
  Future<void> markNotificationAsRead({required String notificationId}) async {
    try {
      await supabase
          .from('notifications')
          .update({'is_read': true}).eq('id', notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  @override
  Future<void> sendNotification(
      {required String userId,
      required String title,
      required String body,
      String? metadata}) async {
    try {
      await supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'body': body,
        'metadata': metadata ?? {},
        'is_read': false,
      });
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  @override
  Stream<List<NotificationEntity>> watchNotifications(
      {required String userId}) {
    final controller = StreamController<List<NotificationModel>>.broadcast();
    final res = supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50)
        .asStream();

    res.listen((data) {
      final notifications =
          data.map((e) => NotificationModel.fromMap(e)).toList();
      controller.add(notifications);
    }, onError: (error) {
      controller.addError('Failed to watch notifications: $error');
    });

    return controller.stream.map(
        (notifications) => notifications.map((e) => e.toEntity()).toList());
  }

  @override
  Future<int> fetchUnreadCount({required String userId}) async{
    try{
      final res=await supabase
      .from('notifications')
      .select()
      .eq('user_id', userId)
      .eq('is_read', false)
      .count();
      return res.count;
    }
    catch (e) {
      throw Exception('Failed to fetch unread count: $e');
    }
  }
}
