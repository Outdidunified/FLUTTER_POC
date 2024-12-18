// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class NotificationTogglePage extends StatefulWidget {
//   @override
//   _NotificationTogglePageState createState() => _NotificationTogglePageState();
// }
//
// class _NotificationTogglePageState extends State<NotificationTogglePage> {
//   bool _isNotificationsEnabled = false;
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//     _checkPermission();
//   }
//
//   // Check the notification permission status
//   void _checkPermission() async {
//     PermissionStatus status = await Permission.notification.status;
//     print(status);
//     setState(() {
//       _isNotificationsEnabled = status.isGranted;
//     });
//   }
//
//   // Handle the toggle for enabling/disabling notifications
//   void _toggleNotifications(bool value) async {
//     if (value) {
//       // Request permission if notifications are enabled
//       PermissionStatus status = await Permission.notification.request();
//       // print("notification:${status});
//       //
//       if (status.isGranted) {
//         setState(() {
//           _isNotificationsEnabled = true;
//         });
//         print('Notifications enabled.');
//       } else {
//         setState(() {
//           _isNotificationsEnabled = false;
//         });
//         print('Notification permission denied.');
//       }
//     } else {
//       // Disable notifications (update state only)
//       setState(() {
//         _isNotificationsEnabled = false;
//       });
//       print('Notifications disabled.');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       ListTile(
//         leading: Icon(Icons.notifications),
//         title: Text('Notifications'),
//         trailing: Switch(
//           value: _isNotificationsEnabled,
//           onChanged: _toggleNotifications,
//         ),
//       );
//   }
// }