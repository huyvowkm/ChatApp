import 'package:chat_app/data_source/remote/message_remote_data_source.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final messageRepoProvider = Provider<MessageRepo>(
  (ref) => MessageRepo(ref.read(messageRemoteProvider))
);

class MessageRepo {
  late final MessageRemoteDataSource _messageRemote;
  MessageRepo(MessageRemoteDataSource messageRemote) {
    _messageRemote = messageRemote;
  }

  SupabaseStreamBuilder initRealtimeMessagesStream(List<String> idChats) {
    return _messageRemote.initRealtimeMessagesStream(idChats);
  }

  Future<MessageModel> getMessageById(String idMessage) async {
    return await _messageRemote.getMessageById(idMessage);
  } 
}