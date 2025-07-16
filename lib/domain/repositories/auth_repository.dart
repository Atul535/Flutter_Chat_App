import 'package:chat_app/core/utils/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String mobile,
    required String password,
  });

  Future<Either<Failure, String>> loginEmailAndPassword({
    required String email,
    required String password,
  });

  
}
