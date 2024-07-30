import 'package:chat_app/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MessageWidget extends StatelessWidget {
  MessageModel message;
  bool isSentByCurrentUser;
  MessageWidget(this.message, { required this.isSentByCurrentUser, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isSentByCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Visibility(
          visible: !isSentByCurrentUser,
          child: _avatar()
        ),
        _messageBox(context),
      ],
    );
  }

  Widget _messageBox(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      constraints: BoxConstraints(maxWidth: 0.7 * screenWidth),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      decoration: BoxDecoration(
        color: isSentByCurrentUser ? Colors.blue : Colors.grey[700],
        borderRadius: BorderRadius.circular(20)
      ),
      child: Text(
        message.content, 
        maxLines: null,
        // overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      )
    );
  }

  Widget _avatar() {
    return  Container(
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: FlutterLogo(size: 30)
    );
  }
}