import 'package:chat_app/core/utils/exception.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/data/datasources/auth_remote_data_source.dart';
import 'package:chat_app/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  const AuthRepositoryImpl(this.authRemoteDataSource);
  @override
  Future<Either<Failure, String>> loginEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement loginEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    try {
      final userId = await authRemoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        mobile: mobile,
        password: password,
      );
      return right(userId);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
