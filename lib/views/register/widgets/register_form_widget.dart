import 'package:chat_app/utils/validators.dart';
import 'package:chat_app/views/register/register_view_model.dart';
import 'package:chat_app/widgets/password_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterFormWidget extends ConsumerWidget {
  const RegisterFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const formSpacer = SizedBox(height: 10);
    return Form(
      key: ref.watch(registerViewModel).formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          TextFormField(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: ref.read(registerViewModel).nameController,
            decoration: InputDecoration(
              labelText: 'Your name',
              hintText: 'Enter your name',
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
          TextFormField(
            validator: validateEmail,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: ref.read(registerViewModel).emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Your email',
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
            controller: ref.read(registerViewModel).passwordController,
            label: const Text('Password'),
          ),
          formSpacer,
          PasswordTextFieldWidget(
            validator: validateEmpty,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: ref.read(registerViewModel).confirmPasswordController,
            label: const Text('Confirm password'),
          ),
          formSpacer,
        ]
      ),
    );
  }
}