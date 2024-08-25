import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationService {
  // Singleton Pattern
  static final FirebaseNotificationService _instance = FirebaseNotificationService._internal();

  factory FirebaseNotificationService() {
    return _instance;
  }

  FirebaseNotificationService._internal();

  // Firebase Messaging Instance
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Initialize Firebase (without getting token)
  Future<void> initialize() async {
    await Firebase.initializeApp();

    // Request permissions (iOS only)
    await _requestPermission();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_onMessageHandler);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle notification click when app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);
  }

  // Request notification permissions for iOS
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

  // Handler for foreground messages
  void _onMessageHandler(RemoteMessage message) {
    print('Received a message while in the foreground!');
    if (message.notification != null) {
      print('Notification Title: ${message.notification?.title}');
      print('Notification Body: ${message.notification?.body}');
      // You can show a local notification or handle the message data here
    }
  }

  // Handler for when the app is opened via notification click
  void _onMessageOpenedAppHandler(RemoteMessage message) {
    print('Message clicked!');
    // Handle what happens when the notification is clicked
  }

  // Background message handler (this should be a top-level function)
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
    // Handle background message data here
  }

  // Method to get FCM token (use when user logs in)
  Future<String?> getToken() async {
    String? token = await _messaging.getToken();
    print('FCM Token: $token');
    return token;
  }

  // Method to subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  // Method to unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }
}
