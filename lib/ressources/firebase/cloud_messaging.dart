import 'dart:convert';

import 'package:chedmed/blocs/chat_bloc.dart';
import 'package:chedmed/models/message.dart' as models;
import 'package:chedmed/models/token_request.dart';
import 'package:chedmed/ressources/repository/repository.dart';
import 'package:chedmed/ressources/shared_preference/shared_preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import '../../firebase_options.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CloudMessagingService {
  static FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static PublishSubject<models.Message> _messageFetcher =
      PublishSubject<models.Message>();
  static Stream<models.Message> get getMessages => _messageFetcher.stream;

  static initFireBase() async {
    await _initNotifications();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      var data = remoteMessage.data;
      var message = models.Message.fromJson(json.decode(data["message"]));
      print('received');
      print(message.userName);
      _messageFetcher.sink.add(message);
      if (chatBloc.getCurrentConversationId == message.conversation_id) return;
      _displayNotification(message.userName!, message.body);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage remoteMessage) async {
    await Firebase.initializeApp();

    var data = remoteMessage.data;
    var message = models.Message.fromJson(json.decode(data["message"]));

    try {
      _messageFetcher.sink.add(message);
    } catch (e) {}

    _displayNotification(message.userName!, message.body);
  }

  static Future<void> updateUserToken() async {
    FirebaseMessaging.instance.getToken().then((token) async {
      print("updating token ... ." + token!);
      await chedMedApi.uptadeUserToken(TokenRequest(token: token));
    });
  }

  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static _initNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: (a, b, c, d) {});
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (paylod) async {
      await SharedPreferenceData.saveNotificationMessagePending(true);
      print(SharedPreferenceData.loadNotificationMessagePending());
    });
  }

  static List<Message> _messagesQue = [];

  static _displayNotification(String userName, String body) async {
    await _initNotifications();
    Person person = Person(
      name: userName,
    );

    _messagesQue.add(Message(body, DateTime.now(), person));

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation:
                MessagingStyleInformation(person, messages: _messagesQue),
            ticker: 'ticker');
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
        0, userName, jsonEncode(body), platformChannelSpecifics,
        payload: body);
  }
}
