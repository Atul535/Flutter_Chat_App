import 'package:chat_app/core/theme/colors.dart';
import 'package:chat_app/presentation/notification/bloc/notification_bloc.dart';
import 'package:chat_app/presentation/notification/bloc/notification_event.dart';
import 'package:chat_app/presentation/notification/widget/notification_list.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      debugPrint('NotificationPage.initState: no authenticated user found.');
      return;
    }
    context
        .read<NotificationBloc>()
        .add(StartWatchingNotifications(userId: user.id));
  }

  @override
  void dispose() {
    context.read<NotificationBloc>().add(StopWatchingNotifications());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      backgroundColor: AppPallete.backgroundColor,
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationLoaded) {
            return NotificationList(
              notifications: state.notifications,
              onMarkRead: (notificationId) {
                context.read<NotificationBloc>().add(
                      MarkNotificationAsRead(notificationId),
                    );
              },
            );
          } else if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(fontSize: 18, color: AppPallete.greyColor),
              ),
            );
          }
        },
      ),
    );
  }
}
