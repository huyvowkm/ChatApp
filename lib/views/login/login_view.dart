import 'package:chat_app/utils/snackbar.dart';
import 'package:chat_app/views/login/login_view_model.dart';
import 'package:chat_app/views/login/widgets/login_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginState(); 
}

class _LoginState extends ConsumerState<LoginView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context)
    );
  }

  AppBar _appBar() {
    return AppBar();
  }

  Widget _body(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        const SizedBox(height: 100),
        const Text('Chat App', textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
        const SizedBox(height: 30),
        const LoginFormWidget(),
        ElevatedButton(
          onPressed: () async {
            final user = await ref.read(loginViewModel).signInWithPassword();
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              showSnackBar(context, 'Invalid account');
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.lightBlue[600],
          ),
          child: const Text('Sign in')
        ),
        const SizedBox(height: 30),
        const Divider(),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey,
            backgroundColor: Colors.grey[900],
          ),
          child: const Text('Create new account')
        ),
      ] 
    );
  }

}