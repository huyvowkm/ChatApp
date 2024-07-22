import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModel = ChangeNotifierProvider<LoginViewModel>(
  (ref) => LoginViewModel(ref.read(userRepoProvider))
);

class LoginViewModel extends ChangeNotifier {

  late final UserRepo _userRepo;
  LoginViewModel(UserRepo userRepo) {
    _userRepo = userRepo;
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> signInWithPassword() async {
    final email = emailController.text;
    final password = passwordController.text;
    await _userRepo.signInWithPassword(email, password);
  }
  
}