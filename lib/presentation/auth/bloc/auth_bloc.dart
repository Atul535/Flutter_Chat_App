import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/data/auth/model/user_model.dart';
import 'package:chat_app/domain/auth/entities/user.dart';
import 'package:chat_app/domain/auth/usecases/current_user.dart';
import 'package:chat_app/domain/auth/usecases/logout_user.dart';
import 'package:chat_app/domain/auth/usecases/update_profile.dart';
import 'package:chat_app/domain/auth/usecases/user_login.dart';
import 'package:chat_app/domain/auth/usecases/user_sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp; //from usecases
  final UserLogin _userLogin; //from usecases
  final CurrentUser _currentUser;
  final LogoutUser _logoutUser; //from usecases
  final UpdateProfile _updateProfile; //from usecases
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required LogoutUser logoutUser,
    required UpdateProfile updateProfile,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _logoutUser = logoutUser,
        _updateProfile = updateProfile,
        super(AuthInitial()) {
    on<AuthSignup>((event, emit) async {
      emit(AuthLoading());
      final res = await _userSignUp(UserSignupParams(
        name: event.name,
        email: event.email,
        mobile: event.mobile,
        password: event.password,
      ));
      res.fold(
        (left) => emit(AuthFailure(left.message)),
        (user) => emit(AuthSuccess(user)),
      );
    });
    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      final res = await _userLogin(UserLoginParams(
        email: event.email,
        password: event.password,
      ));
      res.fold(
        (left) => emit(AuthFailure(left.message)),
        (user) => emit(AuthSuccess(user)),
      );
    });

    on<AuthCurrentUser>((event, emit) async {
      emit(AuthLoading());
      final res = await _currentUser(NoParams());
      res.fold(
        (left) => emit(AuthFailure(left.message)),
        (user) => emit(AuthSuccess(user)),
      );
    });

    on<AuthUserLoggedOut>((event, emit) async {
      emit(AuthLoading());
      final result = await _logoutUser(NoParams());
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (_) => emit(AuthUnauthenticated()),
      );
    });

    on<AuthUpdateProfile>((event, emit) async {
      emit(AuthLoading());
      final res = await _updateProfile(UpdateProfileParams(
        name: event.name,
        mobile: event.mobile,
        email: event.email,
      ));
      res.fold(
        (left) => emit(AuthFailure(left.message)),
        (user) => emit(AuthSuccess(user)),
      );
    });
  }
}
