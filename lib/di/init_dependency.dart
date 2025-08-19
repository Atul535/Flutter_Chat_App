import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/core/supabase_url/app_secrets.dart';
import 'package:chat_app/data/auth/datasources/auth_remote_data_source.dart';
import 'package:chat_app/data/auth/repositories/auth_repository_impl.dart';
import 'package:chat_app/data/chat/datasource/chat_remote_data_source_impl.dart';
import 'package:chat_app/data/chat/datasource/contact_remote_data_source_impl.dart';
import 'package:chat_app/data/chat/repositories/chat_repository_impl.dart';
import 'package:chat_app/data/chat/repositories/contact_repository_impl.dart';
import 'package:chat_app/domain/auth/repositories/auth_repository.dart';
import 'package:chat_app/domain/auth/usecases/current_user.dart';
import 'package:chat_app/domain/auth/usecases/logout_user.dart';
import 'package:chat_app/domain/auth/usecases/update_profile.dart';
import 'package:chat_app/domain/auth/usecases/user_login.dart';
import 'package:chat_app/domain/auth/usecases/user_sign_up.dart';
import 'package:chat_app/domain/chat/repositories/chat_repository.dart';
import 'package:chat_app/domain/chat/repositories/contact_repository.dart';
import 'package:chat_app/domain/chat/usecases/add_contact.dart';
import 'package:chat_app/domain/chat/usecases/get_contacts.dart';
import 'package:chat_app/domain/chat/usecases/get_conversation_previews.dart';
import 'package:chat_app/domain/chat/usecases/get_message.dart';
import 'package:chat_app/domain/chat/usecases/send_message.dart';
import 'package:chat_app/presentation/auth/bloc/auth_bloc.dart';
import 'package:chat_app/presentation/chat/bloc/chat_bloc.dart';
import 'package:chat_app/presentation/contact/bloc/contact_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependency() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton<Connectivity>(() => Connectivity());
  serviceLocator.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(serviceLocator()));

  _initAuth();
  _initChat();
  _initContact();
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
    ..registerFactory<UpdateProfile>(() => UpdateProfile(serviceLocator()))
    ..registerFactory<AuthBloc>(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          logoutUser: serviceLocator(),
          updateProfile: serviceLocator(),
        ));
}

void _initChat() {
  serviceLocator
    ..registerFactory<ChatRemoteDataSource>(
        () => ChatRemoteDataSourceImpl(serviceLocator<SupabaseClient>()))
    ..registerFactory<ChatRepository>(
        () => ChatRepositoryImpl(serviceLocator<ChatRemoteDataSource>()))
    ..registerFactory<GetMessage>(
        () => GetMessage(serviceLocator<ChatRepository>()))
    ..registerFactory<SendMessage>(
        () => SendMessage(serviceLocator<ChatRepository>()))
    ..registerFactory<GetConversationPreviews>(
        () => GetConversationPreviews(serviceLocator()))
    ..registerFactory<ChatBloc>(() => ChatBloc(
          getMessage: serviceLocator<GetMessage>(),
          sendMessage: serviceLocator<SendMessage>(),
          getConversationPreviews: serviceLocator<GetConversationPreviews>(),
        ));
}

void _initContact() {
  serviceLocator
    ..registerFactory<ContactRemoteDataSource>(
        () => ContactRemoteDataSourceImpl(serviceLocator<SupabaseClient>()))
    ..registerFactory<ContactRepository>(
        () => ContactRepositoryImpl(serviceLocator<ContactRemoteDataSource>()))
    ..registerFactory<AddContact>(() => AddContact(serviceLocator()))
    ..registerFactory<GetContacts>(() => GetContacts(serviceLocator()))
    ..registerFactory<ContactBloc>(() => ContactBloc(
          serviceLocator<GetContacts>(),
          serviceLocator<AddContact>(),
        ));
}
