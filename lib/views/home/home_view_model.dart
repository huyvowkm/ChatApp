import 'dart:async';
import 'dart:developer';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/repositories/chat_repo.dart';
import 'package:chat_app/repositories/message_repo.dart';
import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

final homeViewModel = ChangeNotifierProvider(
  (ref) => HomeViewModel(
    ref.read(userRepoProvider), 
    ref.read(chatRepoProvider),
    ref.read(messageRepoProvider)
  )
);

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(UserRepo userRepo, ChatRepo chatRepo, MessageRepo messageRepo) {
    _userRepo = userRepo;
    _chatRepo = chatRepo;
    _messageRepo = messageRepo;
  }

  late final UserRepo _userRepo;
  late final ChatRepo _chatRepo;
  late final MessageRepo _messageRepo;
  StreamSubscription? realtimeChats;
  StreamSubscription? realtimeMessage;
  List<ChatModel> chats = List.empty(growable: true);

  Future<void> loginToOneSignal() async {
    await OneSignal.User.addAlias('external_id', _userRepo.user!.id);
    await OneSignal.login(_userRepo.user!.id);
  }

  Future<void> getChatsByUser() async {
    chats = await _chatRepo.getChatsByUser(_userRepo.user!.id);
    log('Chats: ${chats.map((chat) => chat.toJson())}');
    notifyListeners();
  }

  Future<void> initRealtimeChatsStream() async {
    await realtimeChats?.cancel();
    
    realtimeChats = _chatRepo
      .initRealtimeChatsStream(_userRepo.user!.id)
      .listen((data) async {
        for (var row in data) {
          if (chats.indexWhere((chat) => chat.id == row['id_chat']) == -1) {
            final newChat = await _chatRepo.getChatById(row['id_chat'], _userRepo.user!.id);
            log('New chat: ${newChat.toJson().toString()}');
            chats = [...chats, newChat];
          }
        }
        notifyListeners();
    });
  }

  Future<void> initLastMessagesStream() async {
    await realtimeMessage?.cancel();
    
    realtimeMessage = _messageRepo
      .initLastMessagesStream(chats.map((chat) => chat.id).toList())
      .listen((data) async {
        if (chats.isEmpty) return; 
        for (var row in data) {
          final newMessage = await _messageRepo.getMessageById(row['id']);
          log('Latest message: ${newMessage.toJson().toString()}');
          final chat = chats.firstWhere((chat) => chat.id == newMessage.to);
          chat.lastMessage = newMessage;
          chats.remove(chat);
          chats.insert(0, chat);
        }
        notifyListeners();
    });
  }

  /// Refresh home view every 1 minute
  /// based on available data, not fetch new data
  void autoUpdate() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    realtimeChats?.cancel();
    realtimeMessage?.cancel();
    super.dispose();
  }
}