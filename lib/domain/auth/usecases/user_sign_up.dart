import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/auth/entities/user.dart';
import 'package:chat_app/domain/auth/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignupParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignupParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      mobile: params.mobile,
      password: params.password,
    );
  }
}

class UserSignupParams {
  final String name;
  final String email;
  final String mobile;
  final String password;

  UserSignupParams({
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
  });
}
