import 'package:chat_app/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final messageRemoteProvider = Provider<MessageRemoteDataSource>(
  (ref) => MessageRemoteDataSource()
);

class MessageRemoteDataSource {
  final _supabase = Supabase.instance.client;

  Future<MessageModel> getMessageById(String idMessage) async {
    final messageJson = await _supabase  
      .from('message')
      .select('*, user(*)')
      .eq('id', idMessage)
      .single();
    return MessageModel.fromJson(messageJson);
  }

  Future<List<MessageModel>> getMessagesByChat(String idChat) async {
    List<MessageModel> messages = [];
    await _supabase
      .from('message')
      .select('*, user(*)')
      .eq('to', idChat)
      .limit(100).then((value) {
        messages = value.map(
          (messageJson) => MessageModel.fromJson(messageJson)
        ).toList();
    });
    return messages;
  }

  SupabaseStreamBuilder initLastMessagesStream(List<String> idChats) {
    return _supabase  
      .from('message')
      .stream(primaryKey: ['id'])
      .inFilter('to', idChats)
      .order('created_at')
      .limit(1);
  } 

  SupabaseStreamBuilder initRealtimeMessagesStream(String idChat) {
    return _supabase
      .from('message')
      .stream(primaryKey: ['id'])
      .eq('to', idChat)
      .order('created_at')
      .limit(1);
  }

  /// Send message with [content] from user with id [from] to chat with id [to] 
  Future<void> sendMessage({required String content, required String from, required String to}) async {
    await _supabase.from('message')
    .insert({
      'content': content,
      'from': from,
      'to': to
    });
  } 
}