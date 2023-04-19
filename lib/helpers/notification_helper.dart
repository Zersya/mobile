import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  // description
  importance: Importance.high,
);

/// Handle all notification service
class NotificationHelper {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late NotificationDetails _platformChannelSpecifics;

  /// Initialize notification service
  Future<void> initialize() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
        '@drawable/ic_stat_qazwa_initial_transparent');

    const initializationSettingsIOS = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await _requestPermissionNotification();

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'user_id_1',
      'user',
      channelDescription: 'Users application',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: '@drawable/ic_stat_qazwa_initial_transparent',
    );

    _platformChannelSpecifics =
        const NotificationDetails(android: androidPlatformChannelSpecifics);

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _setupFCM();
  }

  /// Manually show notification
  Future<void> show(
    int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) async {
    await _flutterLocalNotificationsPlugin
        .show(id, title, body, _platformChannelSpecifics, payload: payload);
  }

  Future<void> _requestPermissionNotification() async {
    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .createNotificationChannel(androidChannel);
    } else if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  Future<void> _setupFCM() async {
    FirebaseMessaging.onBackgroundMessage(_myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        GetIt.I<FlutterLocalNotificationsPlugin>().show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              androidChannel.id,
              androidChannel.name,
              channelDescription: androidChannel.description,
              icon: '@drawable/ic_stat_qazwa_initial_transparent',
            ),
          ),
        );
      }
    });

    // FirebaseMessaging.instance.onTokenRefresh
    //     .listen((fcmToken) {})
    //     .onError((dynamic err) {});
  }

  static Future<dynamic> _myBackgroundMessageHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();

    // if (message.containsKey('data')) {
    //   // Handle data message
    //   final dynamic data = message['data'];
    // }

    // if (message.containsKey('notification')) {
    //   // Handle notification message
    //   final dynamic notification = message['notification'];
    // }
  }
}