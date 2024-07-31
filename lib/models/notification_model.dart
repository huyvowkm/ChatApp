class NotificationModel {
  NotificationModel({
    required this.title,
    required this.content,
    required this.targetChatId
  });

  String title;
  String content;
  String targetChatId;

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'target_chat_id': targetChatId,
  };
}