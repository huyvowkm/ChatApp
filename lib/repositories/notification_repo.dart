import 'package:chat_app/data_source/remote/notification_remote_data_source.dart';
import 'package:chat_app/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepoProvider = Provider<NotificationRepo>(
  (ref) => NotificationRepo(ref.read(notificationRemoteProvider))
);

class NotificationRepo {
  NotificationRepo(NotificationRemoteDataSource notificationRemoteDataSource) {
    _notificationRemoteDataSource = notificationRemoteDataSource;
  }

  late final NotificationRemoteDataSource _notificationRemoteDataSource;

  Future<void> createNotification(NotificationModel notification) async {
    await _notificationRemoteDataSource.createNotification(notification);
  }
}