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
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final chatViewModel = ChangeNotifierProvider.autoDispose<ChatViewModel>(
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
  ChatModel chat = ChatModel();
  late UserModel currentUser;
  final sendMessageController = TextEditingController();
  final messageScrollController = ScrollController();
  bool canSendMessage = false;

  void getChatUsers(List<UserModel> users) {
    chat.users = users;
    currentUser = _userRepo.user!;
  }

  Future<void> getChatInfo(String idChat) async {
    chat = await _chatRepo.getChatById(idChat, _userRepo.user!.id);
  }

  Future<void> getMessagesByChat(String idChat) async {
    messages = await _messageRepo.getMessagesByChat(idChat);
    log('Messages: ${messages.map((message) => message.toJson())}');
    notifyListeners();
  }

  void initRealtimeMessagesStream(String idChat) {
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
      to: chat.id
    );
    sendMessageController.clear();
    scrollDown();
    _notificationRepo.createNotification(NotificationModel(
      title: _userRepo.user!.name,
      content: messageContent,
      targetUsersId: chat.users.where((user) => user.id != _userRepo.user!.id)
        .map((user) => user.id).toList()
    ));
  }

  /// Used when a user wants to send message to a new user
  Future<void> sendFirstMessage() async {
    // create new chat
    final newChat = await _chatRepo.addNewChat();
    chat.id = newChat.id;
    chat.name = newChat.name;

    // create new message
    await sendMessage();

    // add new user to chat
    for (var user in chat.users) {
      await _chatRepo.addNewChatUser(chat.id, user.id);
    }
  
    getMessagesByChat(chat.id);
    initRealtimeMessagesStream(chat.id);
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

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // print(images.map((img) => img.path));
    if (image == null) return;
    try {
      final imageUrl = await _messageRepo.sendImage(image: image);
      await _messageRepo.sendMessage(
        content: imageUrl,
        from: _userRepo.user!.id,
        to: chat.id,
      );
      scrollDown();
      _notificationRepo.createNotification(NotificationModel(
        title: _userRepo.user!.name,
        content: 'New message',
        targetUsersId: chat.users.where((user) => user.id != _userRepo.user!.id)
          .map((user) => user.id).toList()
      )); 
    } on StorageException catch (error) {
      debugPrint(error.toString());
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  bool isPickingImage = false;
}