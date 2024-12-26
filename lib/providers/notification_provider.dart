import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:forex_mountain/utils/default_logger.dart';
import '/database/model/response/additional/fcm_notification_model.dart';
import '/sl_container.dart';
import '/utils/notification_sqflite_helper.dart';

class NotificationProvider with ChangeNotifier {
  final NotificationDatabaseHelper notificationDatabaseHelper;

  NotificationProvider({required this.notificationDatabaseHelper});

  StreamController<List<Map<String, dynamic>>> notifications =
  StreamController<List<Map<String, dynamic>>>.broadcast();

  var totalUnread = 0;

  Future<void> init() async {
    List<Map<String, dynamic>> notificationList = await sl.get<NotificationDatabaseHelper>().listenToSqlNotifications();

    // Add the fetched notifications to the stream
    notifications.add(notificationList);

    // Log the fetched notification data
    infoLog('notification fetched from local db successfully!👏');

    // Print each notification data entry for better clarity
    for (var notification in notificationList) {
      infoLog('Fetched Notification: $notification');
    }
  }

  Future<void> markRead(int id) async {
    await sl
        .get<NotificationDatabaseHelper>()
        .updateItem(id, {'isRead': 1})
        .then((value) async => notifications.add(await sl
        .get<NotificationDatabaseHelper>()
        .listenToSqlNotifications()))
        .then((value) => getUnRead());

    infoLog('notification fetched from local db successfully!👏');
  }

  Future<int> getUnRead() async {
    totalUnread = (await sl.get<NotificationDatabaseHelper>().getItems())
        .where((msg) => msg['isRead'] == 0)
        .length;
    notifyListeners();
    return totalUnread;
  }

  clear() {
    notifications.add([]);
  }
}

