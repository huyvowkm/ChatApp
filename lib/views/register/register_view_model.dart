import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final registerViewModel = ChangeNotifierProvider<RegisterViewModel>(
  (ref) => RegisterViewModel(ref.read(userRepoProvider))
);

class RegisterViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController(); 
  final formKey = GlobalKey<FormState>();

  late final UserRepo _userRepo;
  RegisterViewModel(UserRepo userRepo) {
    _userRepo = userRepo;
  }

  Future<User?> signUp() async {
    final email = emailController.text;
    final name = nameController.text;
    final password = passwordController.text;
    return await _userRepo.signUp(name, email, password);
  }
}