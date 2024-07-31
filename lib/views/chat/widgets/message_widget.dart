import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  MessageModel message;
  bool isSentByCurrentUser;
  MessageWidget(this.message, { required this.isSentByCurrentUser, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: isSentByCurrentUser ? Colors.blue : Colors.grey[700],
        borderRadius: BorderRadius.circular(15)
      ),
      child: Text(
        '${message.from.name}: ${message.content}', 
        style: const TextStyle(fontSize: 16, color: Colors.white)
      )
    );
  }
}