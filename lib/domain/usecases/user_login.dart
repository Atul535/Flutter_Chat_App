import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/entities/user.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final AuthRepository authRepository;

  UserLogin(this.authRepository);
  @override
  Future<Either<Failure, User>> call(params) async {
    return await authRepository.loginEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}
