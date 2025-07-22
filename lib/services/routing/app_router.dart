// services/routing/app_router.dart

import 'package:chat_app/presentation/auth/pages/login_page.dart';
import 'package:chat_app/presentation/auth/pages/signup_page.dart';
import 'package:chat_app/presentation/chat/pages/chat_page.dart';
import 'package:chat_app/presentation/chat/pages/contact_page.dart';
import 'package:chat_app/presentation/chat/pages/message_page.dart';
import 'package:chat_app/presentation/chat/pages/my_profile.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteNames.signup,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const ChatPage(),
    ),
    GoRoute(
      name: RouteNames.message,
      path: '/message/:senderId/:receiverId',
      builder: (context, state) {
        final senderId = state.pathParameters['senderId']!;
        final receiverId = state.pathParameters['receiverId']!;
        return MessagePage(senderId: senderId, receiverId: receiverId);
      },
    ),
    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) => const MyProfile(),
    ),
    GoRoute(
      path: RouteNames.contact,
      builder: (context, state) => const ContactPage(),
    ),
  ],
);
