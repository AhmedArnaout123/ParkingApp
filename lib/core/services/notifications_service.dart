import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    ///
    tz.initializeTimeZones();
    tz.setLocalLocation(
        tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  void selectNotification(String? payload) async {
    //Handle notification tapped logic here
  }

  Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future show() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'LessonsDatesId', //Required for Android 8.0 or after
      'Lessons Dates', //Required for Android 8.0 or after
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,

      styleInformation: BigTextStyleInformation(''),
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      12345,
      'تنبيه',
      'حجزكم شارف على الانتهاء',
      platformChannelSpecifics,
    );
  }

  Future schdeule(tz.TZDateTime tzDateTime) async {
    ///
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'LessonsDatesId', //Required for Android 8.0 or after
      'Lessons Dates', //Required for Android 8.0 or after
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,

      styleInformation: BigTextStyleInformation(''),
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      12345,
      'تذكير',
      'حجزكم شارف على الانتهاء',
      tzDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("A notification was schdueled at: $tzDateTime");

    // await flutterLocalNotificationsPlugin.zonedSchedule(123, title, body, scheduledDate, notificationDetails, uiLocalNotificationDateInterpretation: uiLocalNotificationDateInterpretation, androidAllowWhileIdle: androidAllowWhileIdle)
  }
}
