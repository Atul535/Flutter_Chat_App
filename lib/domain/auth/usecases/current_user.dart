import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/auth/entities/user.dart';
import 'package:chat_app/domain/auth/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);

  @override
  Future<Either<Failure, User>> call(params) async {
    return await authRepository.currentUser();
  }
}
