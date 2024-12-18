import 'package:flutter/material.dart';
import 'package:my_proj/pages/permissions/background_permission.dart';
import 'package:my_proj/pages/permissions/camera_permission.dart';
import 'package:my_proj/pages/permissions/location_permission.dart';
import 'package:my_proj/pages/permissions/notification_permission.dart';

class HomeFooterPage extends StatefulWidget {
  final String username;
  final String email;
  final int userId;

  const HomeFooterPage({
    super.key,
    required this.username,
    required this.email,
    required this.userId,
  });

  @override
  State<HomeFooterPage> createState() => _HomeFooterPageState();
}

class _HomeFooterPageState extends State<HomeFooterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Manager'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Background Permission
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BackgroundPermission(),
            ),
            // Location Permission
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LocationPermission(),
            ),
            // Camera Permission
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: CameraPermission(),
            // ),
            // // Notification Permission
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: NotificationTogglePage(),
            // ),
          ],
        ),
      ),
    );
  }
}
