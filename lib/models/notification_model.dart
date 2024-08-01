class NotificationModel {
  NotificationModel({
    required this.title,
    required this.content,
    required this.targetUsersId
  });

  String title;
  String content;
  List<String> targetUsersId; 

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'target_users_id': targetUsersId.join(','),
  };
}