import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final splashViewModel = ChangeNotifierProvider(
  (ref) => SplashViewModel(ref.read(userRepoProvider))
);

class SplashViewModel extends ChangeNotifier {
  late final UserRepo _userRepo;
  SplashViewModel(UserRepo userRepo) {
    _userRepo = userRepo;
  }

  User? checkCurrentUser()  {
    return _userRepo.checkCurrentUser();
  }
}