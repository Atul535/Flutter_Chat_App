import 'package:chat_app/domain/usecases/user_sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp; //from usecases
  AuthBloc({
    required UserSignUp userSignUp,
  })  : _userSignUp = userSignUp,
        super(AuthInitial()) {
    on<AuthSignup>((event, emit) async {
      final res = await _userSignUp(UserSignupParams(
        name: event.name,
        email: event.email,
        mobile: event.mobile,
        password: event.password,
      ));
      res.fold((left) => emit(AuthFailure(left.message)),
          (right) => emit(AuthSuccess(right)));
    });
  }
}
