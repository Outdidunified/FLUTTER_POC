import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, required this.username}); // Declare a variable to hold the username

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(child: Text("Welcome $username", style: TextStyle(
          fontSize: 40,
          color: Colors.black
      ), )),
    );
  }
}
