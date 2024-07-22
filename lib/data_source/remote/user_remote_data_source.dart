import 'dart:developer';

import 'package:chat_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final userRemoteProvider = Provider<UserRemoteDataSource>(
  (ref) => UserRemoteDataSource()
);

class UserRemoteDataSource {
  UserRemoteDataSource._();
  static final UserRemoteDataSource _instance = UserRemoteDataSource._();
  final _supabase = Supabase.instance.client;

  factory UserRemoteDataSource() {
    return _instance;
  }

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password
    );
  }

  Future<AuthResponse> signUp(String name, String email, String password) async {
    UserModel userModel = UserModel(
      id: uuid.v4(),
      name: name, 
      email: email
    );
    _supabase.from('user')
    .insert(userModel.toMap())
    .then((value) => log('Insert user to supabase'));
    return await _supabase.auth.signUp(
      email: email,
      password: password
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? checkCurrentUser() {
    return _supabase.auth.currentUser;
  }
}