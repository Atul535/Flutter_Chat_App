import 'package:chat_app/core/theme/theme.dart';
import 'package:chat_app/di/init_dependency.dart';
import 'package:chat_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:chat_app/presentation/chat/bloc/chat_bloc.dart';
import 'package:chat_app/presentation/contact/bloc/contact_bloc.dart';
import 'package:chat_app/services/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependency();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>()..add(AuthCurrentUser()),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ChatBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ContactBloc>(),
        ),
      ],
      child: const MyApp(),  
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Chatter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
    );
  }
}
