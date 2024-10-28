import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/dynamic_image.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class MessageWidget extends StatelessWidget {
  MessageModel message;
  bool isSentByCurrentUser;
  MessageWidget(this.message, { required this.isSentByCurrentUser, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isSentByCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
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
    return message.content.isURL()
      ? DynamicImage(
        message.content,
        width: 0.7 * screenWidth,
        height: 0.7 * screenWidth,
        borderRadius: BorderRadius.circular(12),
      ) 
      : Container(
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
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const FlutterLogo(size: 30)
    );
  }
}