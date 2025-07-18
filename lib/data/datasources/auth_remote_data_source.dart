import 'package:chat_app/core/utils/exception.dart';
import 'package:chat_app/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String mobile,
    required String password,
  });

  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      debugPrint(
          'Supabase Login Response: user=${response.user}, session=${response.session}');
      if (response.user == null) {
        debugPrint("Supabase Login Error: User is null");
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith(email: email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          "name": name,
          'phone': mobile,
        },
      );
      debugPrint(
          'Supabase SignUp Response: user=${response.user}, session=${response.session}');
      if (response.user == null) {
        debugPrint("Supabase SignUp Error: User is null");
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith(email: email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first)
            .copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      final res = await supabaseClient.auth.signOut();
      return res;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
