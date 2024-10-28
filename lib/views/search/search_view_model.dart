import 'dart:developer';

import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/chat_repo.dart';
import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchViewModel = ChangeNotifierProvider(
  (ref) => SearchViewModel(ref.read(userRepoProvider), ref.read(chatRepoProvider))
);

class SearchViewModel extends ChangeNotifier {
  SearchViewModel(UserRepo userRepo, ChatRepo chatRepo) {
    _userRepo = userRepo;
    _chatRepo = chatRepo;
  }

  late final UserRepo _userRepo;
  late final ChatRepo _chatRepo;
  List<ChatModel> result = []; 

  Future<void> filterChatsByName(String name) async {
    final chats = await _chatRepo.filterChatsByName(name, _userRepo.user!.id);
    final users = await _userRepo.filterUsersByName(name, _userRepo.user!.id);
    for (var user in users) {
      if (chats.indexWhere((chat) => chat.name == user.name) == -1) {
        chats.add(genTempChat(user));
      }
    }
    result = chats;
    log('Search result: ${result.map((chat) => chat.toJson()).toString()}');
    notifyListeners();
  }

  ChatModel genTempChat(UserModel user) {
    return ChatModel(
      name: user.name,
      avatar: user.avatar,
      users: [user, _userRepo.user!],
    );
  }
}