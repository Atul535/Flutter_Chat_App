import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUser implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) => repository.logoutUser();
}
