import 'dart:developer';

import 'package:chat_app/models/chat_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final chatRemoteProvider = Provider<ChatRemoteDataSource>(
  (ref) => ChatRemoteDataSource()
);

class ChatRemoteDataSource {
  final _supabase = Supabase.instance.client;

  Future<List<ChatModel>> getChatsByUser(String idUser) async {
    final idChatsJson = await _supabase.from('user')
                                    .select('chat ( id )')
                                    .eq('id', idUser)
                                    .single();

    final chats = <ChatModel>[];
    for (int i = 0; i < idChatsJson['chat'].length; i++) {
      final idChat = idChatsJson['chat'][i]['id'].toString();

      chats.add(await getChatById(idChat, idUser));
    }
    log(chats.map((chat) => chat.toJson()).toString());
    return chats;
  }

  Future<ChatModel> getChatById(String idChat, String idUser) async {
    final chatJson = await _supabase
      .from('chat')
      .select('''
        id,
        name,
        created_at,
        user (
          id,
          name,
          avatar
        )
      ''')
      .eq('id', idChat)
      .single();

    final lastMessageJson = await _supabase
      .from('message')   
      .select('''
        id,
        content,
        created_at,
        to,
        user (*)
      ''')
      .eq('to', idChat)  
      .order('created_at')
      .limit(1)
      .single(); 
    
    return ChatModel(
      id: idChat,
      name: List.from(chatJson['user']).length == 2 ? (chatJson['user'][0]['id'].toString() == idUser ? chatJson['user'][1]['name'] : chatJson['user'][0]['name']) : chatJson['name'],
      createdAt: chatJson['created_at'],
      avatar: List.from(chatJson['user']).length == 2 ? (chatJson['user'][0]['id'].toString() == idUser ? chatJson['user'][1]['avatar'] : chatJson['user'][0]['avatar']) : chatJson['avatar'],
      lastMessage: MessageModel.fromJson(lastMessageJson)
    );
    
  }

  SupabaseStreamBuilder getRealtimeChats(String idUser)  {
    return _supabase
      .from('chat_user')
      .stream(primaryKey: ['id_chat, id_user'])
      .eq('id_user', idUser);
  }


}