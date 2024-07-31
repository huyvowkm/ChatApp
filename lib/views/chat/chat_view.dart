import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/views/chat/chat_view_model.dart';
import 'package:chat_app/views/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatView extends ConsumerStatefulWidget {
  ChatModel chat;
  ChatView(this.chat, {super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {

  @override
  void initState() {
    super.initState();
    ref.read(chatViewModel).getCurrentUser();
    ref.read(chatViewModel).getChatInfo(widget.chat);
    if (widget.chat.id.isNotEmpty) {
      ref.read(chatViewModel).getMessagesByChat(widget.chat.id);
      ref.read(chatViewModel).initRealtimeMessagesStream(widget.chat.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }
  
  AppBar _appBar() {
    return AppBar(
      title: Text(widget.chat.name)
    );
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(right: 10, left: 10, bottom: 10),
        child: Column(
          children: [
            _messagesArea(),
            _sendMessageArea()
          ],
        ),
      ),
    );
  }

  Widget _messagesArea() {
    return Expanded(
      child: ListView(
        reverse: true,
        controller: ref.read(chatViewModel).messageScrollController,
        children: ref.watch(chatViewModel).messages
          .map((message) => MessageWidget(
            message, 
            isSentByCurrentUser: ref.read(chatViewModel).user!.id == message.from.id
        )).toList(),
      ),
    );
  }

  Widget _sendMessageArea() {
    return Container(
      padding: const EdgeInsets.only(top:10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ref.read(chatViewModel).sendMessageController,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1
                  )
                ),
                hintText: 'Enter something...',
              ),
              onChanged: (_) => ref.read(chatViewModel).checkValidMessage(),
            ),
          ),
          IconButton(
            onPressed: ref.read(chatViewModel).canSendMessage
            ? () async => widget.chat.id.isNotEmpty
              ? ref.read(chatViewModel).sendMessage()
              : ref.read(chatViewModel).sendFirstMessage()
            : null,
            icon: const Icon(Icons.send)
          )
        ],
      ),
    );
  }
}