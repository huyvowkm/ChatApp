import 'dart:developer';

import 'package:chat_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chat_app/data_source/remote/user_remote_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRepoProvider = Provider<UserRepo>(
  (ref)=> UserRepo(ref.read(userRemoteProvider))
);

class UserRepo {
  late final UserRemoteDataSource _userRemote;
  UserModel? user;
  UserRepo(UserRemoteDataSource userRemote) {
    _userRemote = userRemote;
  }

  Future<UserModel?> signInWithPassword(String email, String password) async {
    try {
      final authResponse = await _userRemote.signInWithPassword(email, password);
      if (authResponse.user == null) {
        return null;
      }
      user = await _userRemote.getUserById(authResponse.user!.id);
      log(authResponse.session.toString());
      return user;
    } on AuthException catch(err) {
      log(err.toString());
      return null;
    }
  }

  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      final authResponse = await _userRemote.signUp(name, email, password);
      if (authResponse.user == null) {
        return null;
      }
      user = await _userRemote.getUserById(authResponse.user!.id);
      log(authResponse.session.toString());
      return user;
    } on AuthException catch (err) {
      log(err.toString());
      return null;
    } 
  }

  Future<void> signOut() async {
    await _userRemote.signOut();
    user = null;
  }

  Future<UserModel?> checkCurrentUser() async {
    final userAuth = _userRemote.checkAuthUser();
    if (userAuth == null) {
      return null;
    }
    return await _userRemote.getUserById(userAuth.id);
  }

  User? checkAuthUser() {
    final userAuth = _userRemote.checkAuthUser();
    if (userAuth == null) {
      return null;
    }
    _userRemote.getUserById(userAuth.id).then((value) => user = value);
    return userAuth;
  }
  
  Future<UserModel> getUserById(String id) async {
    return await _userRemote.getUserById(id);
  }

  Future<List<UserModel>> filterUsersByName(String name) async {
    return await _userRemote.filterUsersByName(name);
  }
}