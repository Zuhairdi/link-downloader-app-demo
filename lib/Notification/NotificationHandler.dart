import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<bool?> init() async {
    //android
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher');

    //iOS
    final initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    //macintosh
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();

    //setup
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );

    //init
    return localNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (value) async {},
    );
  }

  static progressNotification(int progress) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'link_downloader_channel_0',
      'link_downloader_channel_0',
      'This is a channel for showing a notification for Link Downloader app',
      importance: Importance.low,
      priority: Priority.low,
      icon: null,
      progress: progress,
      maxProgress: 100,
      showProgress: true,
      autoCancel: true,
      playSound: false,
      showWhen: false,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await localNotificationsPlugin.show(
      1111,
      'Downloading',
      '$progress%',
      platformChannelSpecifics,
    );
  }
}
