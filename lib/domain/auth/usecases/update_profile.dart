import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/auth/entities/user.dart';
import 'package:chat_app/domain/auth/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfile implements UseCase<User, UpdateProfileParams> {
  final AuthRepository authRepository;
  UpdateProfile(this.authRepository);
  @override
  Future<Either<Failure, User>> call(params) {
    return authRepository.updateProfile(
      name: params.name,
      mobile: params.mobile,
      email: params.email,
    );
  }
}

class UpdateProfileParams {
  final String name;
  final String mobile;
  final String email;
  UpdateProfileParams({
    required this.name,
    required this.mobile,
    required this.email,
  });
}
