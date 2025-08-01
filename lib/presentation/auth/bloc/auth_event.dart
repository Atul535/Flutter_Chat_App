part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignup extends AuthEvent {
  final String name;
  final String email;
  final String mobile;
  final String password;
  AuthSignup({
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
  });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;
  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthCurrentUser extends AuthEvent {}

class AuthUserLoggedOut  extends AuthEvent {}
