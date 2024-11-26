import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;

  // For showing local notifications
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initialize Firebase Messaging and Firebase Analytics
  Future<void> initNotifications() async {
    try {
      // Request permission for iOS
      await _firebaseMessaging.requestPermission();

      // Get Firebase Cloud Messaging token
      final fcmToken = await _firebaseMessaging.getToken();
      print("Firebase Token: $fcmToken");

      // Handle background and terminated messages
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _handleForegroundMessage(message);
      });

      // Set up local notifications
      await _initializeLocalNotifications();
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  /// Set up local notifications
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Use a valid launcher icon
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  /// Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print("Background Message: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Payload: ${message.data}");
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) async {
    print("Foreground Message Received: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");

    // Log event to Firebase Analytics
    await _logAnalyticsEvent(message);

    // Show local notification
    await _showNotification(message);
  }

  /// Log notification events to Firebase Analytics
  Future<void> _logAnalyticsEvent(RemoteMessage message) async {
    try {
      await _firebaseAnalytics.logEvent(
        name: 'notification_received',
        parameters: {
          'title': message.notification?.title ?? '',
          'body': message.notification?.body ?? '',
        },
      );
    } catch (e) {
      print("Error logging analytics event: $e");
    }
  }

  /// Show local notification
  Future<void> _showNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.high,
        priority: Priority.high,
      );
      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? "Notification",
        message.notification?.body ?? "You have a new message",
        notificationDetails,
        payload: message.data.toString(),
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }
}

