import 'package:chat_app/models/chat_model.dart';
import 'package:flutter/material.dart';

class SearchResultWidget extends StatelessWidget {
  ChatModel chat;
  SearchResultWidget(this.chat, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/chat', arguments: { 'chat': chat });
      },
      child: ListTile(
        leading: chat.avatar.isEmpty ? const FlutterLogo(size: 30): Image.network(chat.avatar),
        title: Text(chat.name),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
      ),
    );
  }
}