import 'dart:developer';

import 'package:chat_app/models/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final chatRemoteProvider = Provider<ChatRemoteDataSource>(
  (ref) => ChatRemoteDataSource()
);

class ChatRemoteDataSource {
  final _supabase = Supabase.instance.client;

  Future<List<ChatModel>> getChatsByUser(String idUser) async {
    final idChatsJson = await _supabase
      .from('user')
      .select('chat ( id )')
      .eq('id', idUser)
      .single();
    final chats = <ChatModel>[];
    for (int i = 0; i < idChatsJson['chat'].length; i++) {
      final idChat = idChatsJson['chat'][i]['id'].toString();
      chats.add(await getChatById(idChat, idUser));
    }
    return chats;
  }

  Future<ChatModel> getChatById(String idChat, String idUser) async {
    final chatJson = await _supabase
      .from('chat')
      .select('*, user(*)')
      .eq('id', idChat)
      .single();
    final lastMessageJson = await _supabase
      .from('message')   
      .select('*, user(*)')
      .eq('to', idChat)  
      .order('created_at')
      .limit(1)
      .single(); 

    chatJson['last_message'] = lastMessageJson;
    log(chatJson.toString());
    return ChatModel.fromJson(chatJson);
  }

  SupabaseStreamBuilder initRealtimeChatsStream(String idUser)  {
    return _supabase
      .from('chat_user')
      .stream(primaryKey: ['id_chat, id_user'])
      .eq('id_user', idUser)
      .order('created_at')
      .limit(1);
  }

  Future<ChatModel> addNewChat() async {
    final chat = ChatModel();
    await _supabase
      .from('chat')
      .insert({})
      .select()
      .single()
      .then((value) {
        chat.id = value['id'];
        chat.createdAt = value['created_at'];
        chat.name = value['name'];
        chat.avatar = value['avatar'];
      });
    return chat;
  }

  /// Add new user with [idUser] into chat with [idChat]
  Future<void> addNewChatUser(String idChat, String idUser) async {
    await _supabase
      .from('chat_user')
      .insert({
        'id_chat': idChat,
        'id_user': idUser
    });
  }

  Future<List<ChatModel>> filterChatsByName(String name, String currentUserId) async {
    final idChatsJson = await _supabase
      .from('user')
      .select('chat ( id )')
      .eq('id', currentUserId)
      .single();
    final idChats = List.from(idChatsJson['chat']).map((chatJson) => chatJson['id'].toString()).toList();
    final chatsJson = await _supabase
      .from('chat')
      .select('*, user(*)')
      .inFilter('id', idChats)
      .ilike('name', '%$name%');
    return chatsJson.map((chatJson) => ChatModel.fromJson(chatJson)).toList();
  }


}