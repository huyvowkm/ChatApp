import 'package:chat_app/models/user_model.dart';

class MessageModel {
  MessageModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.from,
    required this.to
  });

  String id;
  String content;
  String createdAt;
  UserModel from;
  String to; /// id chat

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'],
    content: json['content'],
    createdAt: json['created_at'],
    from: UserModel.fromJson(json['user']),
    to: json['to']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'created_at': createdAt,
    'from': from.toJson(),
    'to': to
  };

}