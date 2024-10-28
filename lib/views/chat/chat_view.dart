import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/views/chat/chat_view_model.dart';
import 'package:chat_app/views/chat/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatView extends ConsumerStatefulWidget {
  String idChat;
  String name;
  String avatar;
  List<UserModel> users;
  ChatView({
    required this.idChat,
    required this.name,
    required this.avatar,
    required this.users,
    super.key
  });

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {

  @override
  void initState() {
    super.initState();
    ref.read(chatViewModel).getChatUsers(widget.users);
    if (widget.idChat.isNotEmpty) {
      ref.read(chatViewModel).getChatInfo(widget.idChat);
      ref.read(chatViewModel).getMessagesByChat(widget.idChat);
      ref.read(chatViewModel).initRealtimeMessagesStream(widget.idChat);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      // bottomSheet: _bottomSheet(),
      persistentFooterButtons: 
        ref.watch(chatViewModel.select((value) => value.isPickingImage))
          ? [
            _bottomSheet(),
          ]
          : null,
      resizeToAvoidBottomInset: false,
    );
  }
  
  AppBar _appBar() {
    return AppBar(
      title: Text(widget.name),
      centerTitle: false,
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
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        children: ref.watch(chatViewModel).messages
          .map((message) => Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: MessageWidget(
              message, 
              isSentByCurrentUser: ref.read(chatViewModel).currentUser.id == message.from.id
            ),
          )).toList(),
      ),
    );
  }

  Widget _sendMessageArea() {
    return Container(
      padding: const EdgeInsets.only(top:10),
      child: Row(
        children: [
          ..._messageOptions(),
          _messageInput(),
          _sendMessageBtn(),
        ],
      ),
    );
  }

  List<Widget> _messageOptions() {
    return [
      _sendImageBtn(),
    ];
  }

  Widget _messageInput() {
    return Expanded(
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
    );
  }

  Widget _sendMessageBtn() {
    return IconButton(
      onPressed: ref.watch(chatViewModel.select((value) => value.canSendMessage))
      ? () => ref.watch(chatViewModel.select((value) => value.chat.id.isNotEmpty))
        ? ref.read(chatViewModel).sendMessage()
        : ref.read(chatViewModel).sendFirstMessage()
      : null,
      icon: const Icon(Icons.send)
    );
  }

  Widget _sendImageBtn() {
    return IconButton(
      onPressed: () {
        ref.read(chatViewModel).pickImage();
      },
      icon: const Icon(Icons.image),
    );
  }

  Widget _bottomSheet() {
    return BottomSheet(
      showDragHandle: true,
      builder: (context) => Container(
        height: 300,
        color: Colors.amber,
      ),
      onClosing: () {},
    );
  }
}