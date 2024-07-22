import 'package:chat_app/utils/validators.dart';
import 'package:chat_app/views/login/login_view_model.dart';
import 'package:chat_app/widgets/password_text_field_widget.dart';
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
      body: _body(ref)
    );
  }

  AppBar _appBar() {
    return AppBar();
  }

  Widget _body(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: ref.read(loginViewModel).formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: ref.read(loginViewModel).emailController,
              decoration: const InputDecoration(
                // labelText: 'Email',
                hintText: 'Enter your email'
              ),
            ),
            PasswordTextFieldWidget(
              validator: validateEmpty,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: ref.read(loginViewModel).passwordController,
              label: const Text('Password'),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _signIn,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightBlue[400],
                    ),
                    child: const Text('Sign in')
                  )
                )
              ],
            )
          ]
        ),
      )
    );
  }

  void _signIn() {
    ref.read(loginViewModel).signInWithPassword();
  }
  
}