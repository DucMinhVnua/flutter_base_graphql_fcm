import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base_graphql_fcm/services/firebase_notifications/services_firebase_notifications_fcm.dart';
import 'package:flutter_base_graphql_fcm/services/firebase_notifications/services_firebase_notifications_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await ServicesNotificationsLocal().showNotification(
      message.notification.hashCode,
      message.data['title'],
      message.data['body'],
      message.data['routeName']);
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

/* =================== MAIN CHÍNH ================== */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await _configureLocalTimeZone();

  String title;

  /* notifications */
  Map<dynamic, dynamic> appLaunchDetails =
      await ServicesNotificationsLocal().checkNotificationAppLaunchDetails();

  if (appLaunchDetails['isAppLaunch']) {
    title = 'App vừa tắt';
  } else {
    title = 'App chưa được tắt';
  }

  /* firebase */
  await ServiceFCM().initFireBase();

  ServiceFCM().loadFCM();
  ServiceFCM().listenFCM();
  ServicesNotificationsLocal().configureDidReceiveLocalNotificationSubject();
  ServicesNotificationsLocal().configureSelectNotificationSubject();

  var a = await ServiceFCM().getToken();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
        color: Colors.red,
        child: Center(child: Text(title)),
      )),
    ),
  );
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
