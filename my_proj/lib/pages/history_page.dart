import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final String username;
  final String email;
  final int userId;

  const HistoryPage({super.key, required this.username, required this.email, required this.userId});
  // const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("History:${widget.username}, ${widget.userId}, ${widget.email}"),
      ),
    );
  }
}
