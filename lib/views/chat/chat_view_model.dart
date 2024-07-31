import 'dart:async';
import 'dart:developer';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/chat_repo.dart';
import 'package:chat_app/repositories/message_repo.dart';
import 'package:chat_app/repositories/notification_repo.dart';
import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => ChatViewModel(
    ref.read(chatRepoProvider), 
    ref.read(userRepoProvider), 
    ref.read(messageRepoProvider),
    ref.read(notificationRepoProvider)
  )
);

class ChatViewModel extends ChangeNotifier {
  ChatViewModel(ChatRepo chatRepo, UserRepo userRepo, MessageRepo messageRepo, NotificationRepo notificationRepo) {
    _chatRepo = chatRepo;
    _userRepo = userRepo;
    _messageRepo = messageRepo;
    _notificationRepo = notificationRepo;
  }

  late final ChatRepo _chatRepo;
  late final UserRepo _userRepo;
  late final MessageRepo _messageRepo;
  late final NotificationRepo _notificationRepo;
  StreamSubscription? realtimeMessages;
  List<MessageModel> messages = List.empty(growable:  true);
  UserModel? user;
  ChatModel? _chat;
  final sendMessageController = TextEditingController();
  final messageScrollController = ScrollController();
  bool canSendMessage = false;

  void getCurrentUser() {
    user = _userRepo.user;
  }

  void getChatInfo(ChatModel chat) {
    _chat = chat;
  }

  Future<void> getMessagesByChat(String idChat) async {
    messages = await _messageRepo.getMessagesByChat(idChat);
    log('Messages: ${messages.map((message) => message.toJson())}');
    notifyListeners();
    // scrollDown();
  }

  void initRealtimeMessagesStream(String idChat)  {
    realtimeMessages?.cancel();
    realtimeMessages = _messageRepo
      .initRealtimeMessagesStream(idChat)
      .listen((data) async {
        for (var row in data) {
          if (messages.isEmpty) return;
          if (messages.indexWhere((message) => message.id == row['id']) == -1) {
            final newMessage = await _messageRepo.getMessageById(row['id']);
            log('New message: ${newMessage.toJson().toString()}');
            messages = [newMessage, ...messages];
          }
        }
        notifyListeners();
    });
  }

  void checkValidMessage() {
    canSendMessage = sendMessageController.text.trim().isNotEmpty;
    notifyListeners();
  }

  Future<void> sendMessage() async {
    final messageContent = sendMessageController.text.trim();
    await _messageRepo.sendMessage(
      content: messageContent,
      from: _userRepo.user!.id,
      to: _chat!.id
    );
    sendMessageController.clear();
    scrollDown();
    _notificationRepo.createNotification(NotificationModel(
      title: _userRepo.user!.name,
      content: messageContent,
      targetChatId: _chat!.id
    ));
  }

  /// Used when a user wants to send message to a new user
  Future<void> sendFirstMessage() async {
    // create new chat
    final newChat = await _chatRepo.addNewChat();
    _chat!.id = newChat.id;
    _chat!.createdAt = newChat.createdAt;

    // create new message
    await sendMessage();

    // add new user to chat
    for (var user in _chat!.users) {
      _chatRepo.addNewChatUser(_chat!.id, user.id);
    }
    getMessagesByChat(_chat!.id);
    initRealtimeMessagesStream(_chat!.id);
    scrollDown();
    notifyListeners();
  }

  void scrollDown() {
    messageScrollController.jumpTo(0);
  }

  @override
  void dispose() {
    realtimeMessages?.cancel();
    super.dispose();
  }
}