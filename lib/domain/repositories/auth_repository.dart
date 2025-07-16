import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String mobile,
    required String password,
  });

  Future<Either<Failure, User>> loginEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
