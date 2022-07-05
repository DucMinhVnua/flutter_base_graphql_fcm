import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_base_graphql_fcm/main.dart';
import 'package:flutter_base_graphql_fcm/screens/screens_homepage.dart';
import 'package:flutter_base_graphql_fcm/screens/screens_secondpage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class ServicesNotificationsLocal {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications',
    'Main channel notifications', // title
    importance: Importance.high,
    enableVibration: true,
  );

  /* show notifications */
  Future<void> showNotification(
      int id, String? title, String? body, String? payload) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            importance: Importance.max, ticker: 'ticker');
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(id, title, body, platformChannelSpecifics, payload: payload);
  }

  /* Khi có thông báo gửi về từ listenFCM -> configureDidReceiveLocalNotificationSubject lắng nghe -> hiển thị thông báo */
  void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await ServicesNotificationsLocal().showNotification(
          receivedNotification.id,
          receivedNotification.title,
          receivedNotification.body,
          receivedNotification.payload);
    });
  }

  /* click thông báo được hiển thị -> onSelectNotification -> showNotification -> configureSelectNotificationSubject -> xử lý logic khi click */
  void configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      if (payload == "1") {
        Get.to(HomePage(title: payload!));
      } else {
        Get.to(SecondPage(title: payload!));
      }
    });
  }

  /* quyền thông báo */
  void requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

/* Kiểm tra ứng dụng bị vuốt chưa */
  Future<Map<dynamic, dynamic>> checkNotificationAppLaunchDetails() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        !kIsWeb && Platform.isLinux
            ? null
            : await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();

    return {
      "isAppLaunch": notificationAppLaunchDetails?.didNotificationLaunchApp,
      "payload": notificationAppLaunchDetails!.payload
    };
  }

/* Tạo mới channel */
  Future<void> createNotificationChannel() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(ServicesNotificationsLocal().channel);
  }
}
