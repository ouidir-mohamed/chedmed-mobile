import 'dart:convert';

import 'package:chedmed/main.dart';
import 'package:chedmed/models/annonce.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:chedmed/ui/recommendations/recommendations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
initNotifications() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(onDidReceiveLocalNotification: (a, b, c, d) {});
  final MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (paylod) {
    notificationTapped(paylod!);
  });
}

displayNotification(String title, String body) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(body),
          ticker: 'ticker');
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, title, jsonEncode(body), platformChannelSpecifics,
      payload: body);
}

notificationTapped(String payload) async {
  Navigator.push(requireContext(),
      MaterialPageRoute(builder: (context) => Recommendations()));
}

handleAppStartup() async {
  var prefs = await SharedPreferences.getInstance();

  var details =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (details!.didNotificationLaunchApp) {
    print("yeah from not");
    await prefs.setBool('notificationPending', true);
  }
}
