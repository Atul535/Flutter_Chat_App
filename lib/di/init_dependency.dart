import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/core/supabase_url/app_secrets.dart';
import 'package:chat_app/data/auth/datasources/auth_remote_data_source.dart';
import 'package:chat_app/data/auth/repositories/auth_repository_impl.dart';
import 'package:chat_app/domain/auth/repositories/auth_repository.dart';
import 'package:chat_app/domain/auth/usecases/current_user.dart';
import 'package:chat_app/domain/auth/usecases/logout_user.dart';
import 'package:chat_app/domain/auth/usecases/user_login.dart';
import 'package:chat_app/domain/auth/usecases/user_sign_up.dart';
import 'package:chat_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator(), serviceLocator()))
    ..registerFactory<UserSignUp>(() => UserSignUp(serviceLocator()))
    ..registerFactory<UserLogin>(() => UserLogin(serviceLocator()))
    ..registerFactory<CurrentUser>(() => CurrentUser(serviceLocator()))
    ..registerFactory<LogoutUser>(() => LogoutUser(serviceLocator()))
    ..registerFactory<AuthBloc>(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          logoutUser: serviceLocator(),
        ));
}
