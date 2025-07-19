import 'package:chat_app/di/init_dependency.dart';
import 'package:chat_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:chat_app/presentation/auth/pages/login_page.dart';
import 'package:chat_app/presentation/auth/pages/signup_page.dart';
import 'package:chat_app/presentation/chat/pages/chat_page.dart';
import 'package:chat_app/presentation/chat/pages/contact_page.dart';
import 'package:chat_app/presentation/chat/pages/message_page.dart';
import 'package:chat_app/presentation/chat/pages/my_profile.dart';
import 'package:chat_app/services/routing/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    stream.listen((_) => notifyListeners());
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  refreshListenable: GoRouterRefreshStream(serviceLocator<AuthBloc>().stream),
  redirect: (context, state) {
    final authState = serviceLocator<AuthBloc>().state;
    final isLoggedIn = authState is AuthSuccess;
    final isLoading = authState is AuthLoading || authState is AuthInitial;
    final goingToAuth = state.fullPath == RouteNames.login ||
        state.fullPath == RouteNames.signup;

    if (isLoading) {}
    if (!isLoggedIn && !goingToAuth) {
      return RouteNames.login;
    }
    if (isLoggedIn && goingToAuth) {
      return RouteNames.home;
    }
    return null;
  },
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
      path: RouteNames.message,
      builder: (context, state) => const MessagePage(),
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
