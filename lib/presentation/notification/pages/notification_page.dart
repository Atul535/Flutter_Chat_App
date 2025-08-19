import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/domain/chat/entities/notification_entity.dart';
import 'package:chat_app/presentation/notification/widget/notification_list.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<NotificationEntity> notifications;
  const NotificationPage({
    super.key,
    required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    final hasNotifications = notifications.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            appRouter.go(RouteNames.home);
          },
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: AppPallete.appBarColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      // body: Center(
      //   child: Text(
      //     'No notifications yet',
      //     style: TextStyle(fontSize: 18, color: Colors.grey),
      //   ),
      // ),
      backgroundColor: AppPallete.backgroundColor,
      body: hasNotifications
          ? NotificationList(notifications: notifications)
          : Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(fontSize: 18, color: AppPallete.greyColor),
              ),
            ),
    );
  }
}
