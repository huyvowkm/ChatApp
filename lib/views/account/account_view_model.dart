import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => AccountViewModel(ref.read(userRepoProvider))
);

class AccountViewModel extends ChangeNotifier {
  late final UserRepo _userRepo;
  UserModel? currentUser;
  AccountViewModel(UserRepo userRepo) {
    _userRepo = userRepo;
  }

  Future<UserModel?> checkCurrentUser() async {
    currentUser = await _userRepo.checkCurrentUser();
    return currentUser;
  }

  Future<void> signOut() async {
    await _userRepo.signOut();
  }

}