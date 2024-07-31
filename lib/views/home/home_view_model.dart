import 'dart:async';
import 'dart:developer';

import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/chat_repo.dart';
import 'package:chat_app/repositories/message_repo.dart';
import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModel = ChangeNotifierProvider.autoDispose(
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
  Stream<List<ChatModel>> a = const Stream.empty();

  Future<UserModel?> checkCurrentUser() async {
    return await _userRepo.checkCurrentUser();
  }

  // Future<void> getChatsByUser() async {
  //   chats = await _chatRepo.getChatsByUser(_userRepo.user!.id);
  //   notifyListeners();
  // }

  Future<void> initRealtimeChatsStream() async {
    await realtimeChats?.cancel();
    
    realtimeChats = _chatRepo
      .initRealtimeChatsStream(_userRepo.user!.id)
      .listen((data) async {
        log(data.toString());
        for (var row in data) {
          final newChat = await _chatRepo.getChatById(row['id_chat'], row['id_user']);
          log(newChat.toJson().toString());
          chats = [...chats, newChat];
        }
        notifyListeners();
    });
  }

  void initRealtimeMessagesStream() {
    realtimeMessage?.cancel();
    
    realtimeMessage = _messageRepo
      .initRealtimeMessagesStream(chats.map((chat) => chat.id).toList())
      .listen((data) async {
        if (data.isEmpty) return; 
        log(data.toString());
        for (var row in data) {
          final newMessage = await _messageRepo.getMessageById(row['id']);
          chats.firstWhere((chat) => chat.id == newMessage.to).lastMessage = newMessage;
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
}