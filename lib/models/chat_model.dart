import 'package:chat_app/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatModel {
  ChatModel({
    required this.id, 
    required this.name, 
    this.avatar,
    required this.createdAt,
    required this.lastMessage
  });

  String id;
  String name;
  String? avatar;
  String createdAt;
  MessageModel lastMessage;
  
  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    id: json['id_chat'],
    name: json['name'],
    avatar: json['avatar'],
    createdAt: json['created_at'],
    lastMessage: MessageModel.fromJson(json['last_message'])
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'avatar': avatar,
    'created_at': createdAt,
    'last_message': lastMessage.toJson()
  };
}

