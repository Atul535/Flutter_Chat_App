import 'package:chat_app/core/utils/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
  /*use case is being used globally and different usecases have diffrent no. of parameters
   so we cannot hardcode the parameters that's why we are using Params type parameter for dynamic value */
}

class NoParams{}