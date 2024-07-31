import 'package:chat_app/models/notification_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final notificationRemoteProvider = Provider<NotificationRemoteDataSource>(
  (ref) => NotificationRemoteDataSource()
);

class NotificationRemoteDataSource {
  final _supabase = Supabase.instance.client;

  Future<void> createNotification(NotificationModel notification) async {
    await _supabase
      .from('notification')
      .insert(notification.toJson());
  }
}