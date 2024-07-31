import 'package:chat_app/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatWidget extends ConsumerWidget {
  ChatModel chat;
  ChatWidget(this.chat, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {},
      leading: chat.avatar == '' ? const FlutterLogo(size: 30) : Image.network(chat.avatar!),
      title: Text(chat.name),
      subtitle: Row(
        children: [
          Flexible(
            child: Text(
              chat.lastMessage.content,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Text(' · '),
          Text(timeago.format(DateTime.parse(chat.lastMessage.createdAt), locale: 'en_short')),
        ],
      ),
      titleTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}