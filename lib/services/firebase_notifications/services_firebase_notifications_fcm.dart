import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base_graphql_fcm/main.dart';
import 'package:flutter_base_graphql_fcm/services/firebase_notifications/services_firebase_notifications_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ServiceFCM {
  /* load thông báo firebase */
  void loadFCM() async {
    if (!kIsWeb) {
      await ServicesNotificationsLocal().createNotificationChannel();

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /* lắng nghe thông báo firebase */
  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var a = 3;
      if (!kIsWeb) {
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: message.notification.hashCode,
            title: message.data['title'],
            body: message.data['body'],
            payload: message.data['routeName'],
          ),
        );
      }
    });
  }

  void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      var a = 3;
      await ServicesNotificationsLocal().showNotification(
          receivedNotification.id,
          receivedNotification.title,
          receivedNotification.body,
          receivedNotification.payload);
    });
  }

  /* lấy token */
  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  /* quyền thông báo */
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print(
          'User declined or has not accepted permission =======================');
    }
  }

  /* khởi tạo firebase */
  Future<void> initFireBase() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              didReceiveLocalNotificationSubject.add(
                ReceivedNotification(
                  id: id,
                  title: title,
                  body: body,
                  payload: payload,
                ),
              );
            });
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );

    /* Vào onSelectNotification khi click thông báo */
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      selectNotificationSubject.add(payload);
    });
  }
}
