import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/data_source/remote/user_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRepoProvider = Provider<UserRepo>(
  (ref)=> UserRepo(ref.read(userRemoteProvider))
);

class UserRepo {
  UserRepo._();
  static final UserRepo _instance = UserRepo._();
  static UserRemoteDataSource? _userRemote;
  User? user;
  factory UserRepo(UserRemoteDataSource userRemote) {
    _userRemote = userRemote;
    return _instance;
  }

  Future<User?> signInWithPassword(String email, String password) async {
    final authResponse = await _userRemote!.signInWithPassword(email, password);
    user = authResponse.user;
    log(authResponse.session.toString());
    return user;
  }

  Future<User?> signUp(String name, String email, String password) async {
    final authResponse = await _userRemote!.signUp(name, email, password);
    user = authResponse.user;
    log(authResponse.session.toString());
    return user;
  }

  Future<void> signOut() async {
    await _userRemote!.signOut();
    user = null;
  }

  User? checkCurrentUser() {
    user = _userRemote!.checkCurrentUser();
    return user;
  }
}