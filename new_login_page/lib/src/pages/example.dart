import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/session.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Handle logout function
  void _handleLogout() async {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    // Clear the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token

    // Clear the session in the SessionProvider
    sessionProvider.logout(); // Log out from the provider session

    // Navigate back to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the username from SessionProvider

    final sessionUsername = Provider.of<SessionProvider>(context).username;
    print("username:$sessionUsername");

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout, // Call logout when the user presses the button
          )
        ],
      ),
      body: Center(
        child: Text(
          "Hello, $sessionUsername!",
          style: TextStyle(fontSize: 40, color: Colors.black),
        ),
      ),
    );
  }
}
