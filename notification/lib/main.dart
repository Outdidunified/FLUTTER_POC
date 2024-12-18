import 'package:flutter/material.dart';
import 'package:notification/screens/walletPage.dart';
import 'package:notification/services/walletnotification.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Required for async initialization
  NotificationService notificationService = NotificationService();
  await notificationService.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Walletpage(),
    );
  }
}
