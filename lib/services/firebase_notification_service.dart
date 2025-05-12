import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../configs/utilities.dart';
import '../screens/notification/notification_bloc.dart';

class FirebaseNotificationService {
  static final FirebaseNotificationService instance = FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => instance;
  FirebaseNotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await Firebase.initializeApp();
    await _initializeLocalNotifications();
    await _requestPermission();
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);
  }


  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/logo');
    DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);

    await localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );

    // Create a notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'general_notifications', // ID
      'General Notifications', // Name
      description: 'This channel is used for important notifications.', // Description
      importance: Importance.max,
    );

    // Register the channel with the system
    await localNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _onMessageHandler(RemoteMessage message) async {
    _showNotification(
        message.notification!.title ?? '',
        message.notification!.body ?? '',
      );

    BlocProvider.of<NotificationBloc>(navigatorKey.currentContext!).add(LoadNotifications());
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'general_notifications',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@drawable/logo',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await localNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      //payload: 'Notification Payload',
    );
  }

  void _onMessageOpenedAppHandler(RemoteMessage message) {
  }

  Future<void> _onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {

    if (notificationResponse.payload != null) {
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }

  Future<String?> getToken() async {
    String? token = await _messaging.getToken();
    return token;
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  Future<void> removeToken() async {
    await _messaging.deleteToken();
  }
}
