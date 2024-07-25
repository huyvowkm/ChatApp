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
  final _supabase = Supabase.instance.client;

  Future<AuthResponse> signInWithPassword(String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password
    );
  }

  Future<AuthResponse> signUp(String name, String email, String password) async {
    final authResponse = await _supabase.auth.signUp(
      email: email,
      password: password
    );
    UserModel userModel = UserModel(
      id: authResponse.user!.id,
      createdAt: DateTime.now().toString(),
      name: name, 
      email: email
    );
    _supabase.from('user')
    .insert(userModel.toJson())
    .then((value) => log('Insert user to supabase'));
    return authResponse;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? checkAuthUser() {
    return _supabase.auth.currentUser;
  }

  Future<UserModel> getUserById(String id) async {
    return await _supabase.from('user')
    .select()
    .eq('id', id)
    .limit(1)
    .single()
    .then((value) => UserModel.fromJson(value));
  }
}