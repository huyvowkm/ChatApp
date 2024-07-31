import 'package:chat_app/utils/snackbar.dart';
import 'package:chat_app/views/register/register_view_model.dart';
import 'package:chat_app/views/register/widgets/register_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        const SizedBox(height: 150),
        const Text('Chat App', textAlign: TextAlign.center, style: TextStyle(fontSize: 30)),
        const SizedBox(height: 30),
        const RegisterFormWidget(),
        ElevatedButton(
          onPressed: () async {
            if (ref.read(registerViewModel).passwordController.text != ref.read(registerViewModel).confirmPasswordController.text) {
              showSnackBar(context, 'Password not match');
              return;
            }
            if (!ref.read(registerViewModel).formKey.currentState!.validate()) {
              return;
            }
            final user = await ref.read(registerViewModel).signUp();
            if (user != null) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              showSnackBar(context, 'Sign up failed');
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.lightBlue[400],
          ),
          child: const Text('Sign up')
        ),
        const SizedBox(height: 30),
        const Divider(),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey,
            backgroundColor: Colors.grey[900],
          ),
          child: const Text('Have an account')
        ),
      ]
    );
  }
}