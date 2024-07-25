import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  UserModel user;
  UserWidget(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
      child: ListTile(
        leading: user.avatar.isEmpty ? const FlutterLogo(size: 30): Image.network(user.avatar),
        title: Text(user.name),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      ),
    );
  }
}