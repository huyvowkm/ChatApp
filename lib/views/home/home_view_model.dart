import 'dart:async';
import 'dart:developer';

import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/chat_repo.dart';
import 'package:chat_app/repositories/message_repo.dart';
import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final homeViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => HomeViewModel(
    ref.read(userRepoProvider), 
    ref.read(chatRepoProvider),
    ref.read(messageRepoProvider)
  )
);

class HomeViewModel extends ChangeNotifier {
  late final UserRepo _userRepo;
  late final ChatRepo _chatRepo;
  late final MessageRepo _messageRepo;
  late final StreamSubscription realtimeChats;
  late final StreamSubscription realtimeMessage;
  HomeViewModel(UserRepo userRepo, ChatRepo chatRepo, MessageRepo messageRepo) {
    _userRepo = userRepo;
    _chatRepo = chatRepo;
    _messageRepo = messageRepo;
    

    // realtimeMessage = _messageRepo
    //   .getRealtimeMessage(chats.map((chat) => chat.id).toList())
    //   .listen((data) async {
    //     if (data.isEmpty) return; 
    //     log(data.toString());
    //     log(chats.map((chat)=>chat.id).toString());
    //     for (var row in data) {
    //       final newMessage = await _messageRepo.getMessageById(row['id']);
    //       chats.firstWhere((chat) => chat.id == newMessage.to).lastMessage = newMessage;
    //       notifyListeners();
    //     }
    // });

    
  }

  List<ChatModel> chats = List.empty(growable: true);
  Stream<List<ChatModel>> a = const Stream.empty();
  Future<UserModel?> checkCurrentUser() async {
    return await _userRepo.checkCurrentUser();
  }

  Future<void> getChatsByUser() async {
    chats = await _chatRepo.getChatsByUser(_userRepo.user!.id);
    notifyListeners();
  }

  void assignChatRepo() {
    realtimeChats = _chatRepo
      .getRealtimeChats(_userRepo.user!.id)
      .listen((data) async {
        for (var row in data) {
          final newChat = await _chatRepo.getChatById(row['id_chat'], row['id_user']);
          chats.add(newChat);
        }
        notifyListeners();
    });
  }

  // Future<void> getRealtimeChats() async {
  //   return _chatRepo.getRealtimeChats(_userRepo.user!.id);
  // }
  void assignMessageRepo() {
    realtimeMessage = _messageRepo
      .getRealtimeMessage(chats.map((chat) => chat.id).toList())
      .listen((data) async {
        if (data.isEmpty) return; 
        log(data.toString());
        log(chats.map((chat)=>chat.id).toString());
        for (var row in data) {
          final newMessage = await _messageRepo.getMessageById(row['id']);
          chats.firstWhere((chat) => chat.id == newMessage.to).lastMessage = newMessage;
          notifyListeners();
        }
    });
  }
}