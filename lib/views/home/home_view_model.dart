import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => HomeViewModel(ref.read(userRepoProvider))
);

class HomeViewModel extends ChangeNotifier {
  late final UserRepo _userRepo;
  HomeViewModel(UserRepo userRepo) {
    _userRepo = userRepo;
  }

  Future<UserModel?> checkCurrentUser() async {
    return await _userRepo.checkCurrentUser();
  }
}