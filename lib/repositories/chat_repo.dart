import 'package:chat_app/data_source/remote/chat_remote_data_source.dart';
import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final chatRepoProvider = Provider<ChatRepo>(
  (ref) => ChatRepo(ref.read(chatRemoteProvider))
);

class ChatRepo {
  late final ChatRemoteDataSource _chatRemote;
  ChatRepo(ChatRemoteDataSource chatRemote) {
    _chatRemote = chatRemote;
  }

  Future<List<ChatModel>> getChatsByUser(String idUser) async {
    final chats = await _chatRemote.getChatsByUser(idUser);
    for (var chat in chats) {
      if (chat.name.isEmpty) {
        chat.name = _genChatName(chat.users, idUser);
      }
    }
    return chats;
  }

  Future<ChatModel> getChatById(String idChat, String idUser) async {
    final chat = await _chatRemote.getChatById(idChat, idUser);
    if (chat.name.isEmpty) {
      chat.name = _genChatName(chat.users, idUser);
    }
    return chat;
  }

  SupabaseStreamBuilder initRealtimeChatsStream(String idUser) {
    return _chatRemote.initRealtimeChatsStream(idUser);
  } 

  Future<ChatModel> addNewChat() async {
    return await _chatRemote.addNewChat();
  }

  Future<void> addNewChatUser(String idChat, String idUser) async {
    await _chatRemote.addNewChatUser(idChat, idUser);
  }

  String _genChatName(List<UserModel> users, String currentUserId) {
    try {
      String name = '';
      for (var user in users) {
        if (user.id != currentUserId) {
          name += '${user.name}, ';
        }
      }
      name = name.substring(0, name.length - 2);
      return name;
    } catch(err) {
      return '';
    }
  }

  /// Filter chats that contains [name] and includes user with [currentUserId]
  Future<List<ChatModel>> filterChatsByName(String name, String currentUserId) async {
    final chats = await _chatRemote.filterChatsByName(name, currentUserId);
    final filterChats = <ChatModel>[];
    for (var chat in chats) {
      if (chat.name.isEmpty) {
        chat.name = _genChatName(chat.users, currentUserId);
        if (!chat.name.contains(name)) {
          filterChats.add(chat);
        }
      } else {
        filterChats.add(chat);
      }
    }
    return chats;
  }
}