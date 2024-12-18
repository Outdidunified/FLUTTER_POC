import 'package:flutter/material.dart';

class HomeFooterPage extends StatefulWidget {
  final String username;
  final String email;
  final int userId;

  const HomeFooterPage({super.key, required this.username, required this.email, required this.userId});
  // const HomeFooterPage({super.key});

  @override
  State<HomeFooterPage> createState() => _HomeFooterPageState();
}

class _HomeFooterPageState extends State<HomeFooterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("Home Page:${widget.username}, ${widget.userId}"),
      ),
    );
  }
}

