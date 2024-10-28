import 'package:chat_app/data_source/remote/message_remote_data_source.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final messageRepoProvider = Provider<MessageRepo>(
  (ref) => MessageRepo(ref.read(messageRemoteProvider))
);

class MessageRepo {
  late final MessageRemoteDataSource _messageRemote;
  MessageRepo(MessageRemoteDataSource messageRemote) {
    _messageRemote = messageRemote;
  }

  Future<MessageModel> getMessageById(String idMessage) async {
    return await _messageRemote.getMessageById(idMessage);
  } 

  Future<List<MessageModel>> getMessagesByChat(String idChat) async {
    return await _messageRemote.getMessagesByChat(idChat);
  }

  SupabaseStreamBuilder initLastMessagesStream(List<String> idChats) {
    return _messageRemote.initLastMessagesStream(idChats);
  }

  SupabaseStreamBuilder initRealtimeMessagesStream(String idChat) {
    return _messageRemote.initRealtimeMessagesStream(idChat);
  }

  Future<void> sendMessage({required String content, required String from, required String to}) async {
    await _messageRemote.sendMessage(
      content: content, 
      from: from, 
      to: to
    );
  }

  Future<String> sendImage({required XFile image}) async {
    return await _messageRemote.sendImage(image: image);
  }
}