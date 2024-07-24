import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/repositories/chat_repo.dart';
import 'package:chat_app/repositories/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewModel = ChangeNotifierProvider.autoDispose(
  (ref) => HomeViewModel(ref.read(userRepoProvider), ref.read(chatRepoProvider))
);

class HomeViewModel extends ChangeNotifier {
  late final UserRepo _userRepo;
  late final ChatRepo _chatRepo;
  HomeViewModel(UserRepo userRepo, ChatRepo chatRepo) {
    _userRepo = userRepo;
    _chatRepo = chatRepo;
  }

  List<ChatModel> chats = List.empty();

  Future<UserModel?> checkCurrentUser() async {
    return await _userRepo.checkCurrentUser();
  }

  Future<void> getChatsByUser() async {
    chats = await _chatRepo.getChatsByUser(_userRepo.user!.id);
    notifyListeners();
  }
}