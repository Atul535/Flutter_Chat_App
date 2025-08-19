import 'package:chat_app/core/network/network_info.dart';
import 'package:chat_app/core/utils/exception.dart';
import 'package:chat_app/core/utils/failure.dart';
import 'package:chat_app/data/auth/datasources/auth_remote_data_source.dart';
import 'package:chat_app/domain/auth/entities/user.dart';
import 'package:chat_app/domain/auth/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;
  const AuthRepositoryImpl(this.authRemoteDataSource, this.networkInfo);
  @override
  Future<Either<Failure, User>> loginEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final user = await authRemoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!await networkInfo.isConnected) {
        return left(
          Failure("No internet connection"),
        );
      } else {
        return right(user);
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    try {
      final user = await authRemoteDataSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        mobile: mobile,
        password: password,
      );
      if (!await networkInfo.isConnected) {
        return left(
          Failure("No internet connection"),
        );
      } else {
        return right(user);
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failure("User is not logged in"));
      }
      if (!await networkInfo.isConnected) {
        return left(
          Failure("No internet connection"),
        );
      } else {
        return right(user);
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logoutUser() async {
    try {
      await authRemoteDataSource.logout();
      if (!await networkInfo.isConnected) {
        return left(
          Failure("No internet connection"),
        );
      } else {
        return right(null);
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String name,
    required String mobile,
    required String email,
  }) async{
    try {
      final user = await authRemoteDataSource.updateProfile(
        name: name,
        mobile: mobile,
        email: email,
      );
      if (!await networkInfo.isConnected) {
        return left(
          Failure("No internet connection"),
        );
      } else {
        return right(user);
      }
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
