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

  SupabaseStreamBuilder getRealtimeMessage(List<String> idChats) {
    return _supabase  
      .from('message')
      .stream(primaryKey: ['id'])
      .inFilter('to', idChats);
  } 
}