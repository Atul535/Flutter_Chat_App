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
