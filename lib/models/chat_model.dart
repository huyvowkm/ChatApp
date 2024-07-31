import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/models/user_model.dart';

class ChatModel {
  ChatModel({
    this.id = '', 
    this.name = '', 
    this.avatar = '',
    this.createdAt = '',
    this.users = const [],
    this.lastMessage
  });

  String id;
  String name;
  String avatar;
  String createdAt;
  List<UserModel> users;
  MessageModel? lastMessage;
  
  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    id: json['id'],
    name: json['name'],
    avatar: json['avatar'],
    createdAt: json['created_at'],
    users: List.from(json['user']).map((userJson) => UserModel.fromJson(userJson)).toList(),
    lastMessage: json['last_message'] != null ? MessageModel.fromJson(json['last_message']) : null
  );
  
  Map<String, dynamic> toJson() => {  
    'id': id,
    'name': name,
    'avatar': avatar,
    'created_at': createdAt,
    'users': users.map((user) => user.toJson()),
    'last_message': lastMessage?.toJson()
  };
}

