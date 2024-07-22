import 'package:chat_app/utils/validators.dart';
import 'package:chat_app/views/login/login_view_model.dart';
import 'package:chat_app/widgets/password_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginFormWidget extends ConsumerWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const formSpacer = SizedBox(height: 10);
    return Form(
      key: ref.read(loginViewModel).formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: ref.read(loginViewModel).emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              border: OutlineInputBorder(
                borderSide: const  BorderSide(
                  width: 1,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(15),
              )
            ),
          ),
          formSpacer,
          PasswordTextFieldWidget(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: ref.read(loginViewModel).passwordController,
            label: const Text('Password'),
          ),
          formSpacer,
        ]
      ),
    );
  }

}