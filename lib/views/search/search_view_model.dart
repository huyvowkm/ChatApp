import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchViewModel = ChangeNotifierProvider(
  (ref) => SearchViewModel(ref.read(userRepoProvider))
);

class SearchViewModel extends ChangeNotifier {
  SearchViewModel(UserRepo userRepo) {
    _userRepo = userRepo;
  }

  late final UserRepo _userRepo;
  List<UserModel> users = []; 

  Future<void> filterUsersByName(String name) async {
    users = await _userRepo.filterUsersByName(name);
    notifyListeners();
  }
}