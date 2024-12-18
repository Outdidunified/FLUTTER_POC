import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final int userId;

  const ProfilePage({super.key, required this.username, required this.email, required this.userId});
  // const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Profile:${widget.email}, ${widget.userId}, ${widget.username}"),
      ),
    );
  }
}
