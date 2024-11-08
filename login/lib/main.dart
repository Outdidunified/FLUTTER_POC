import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:provider/provider.dart';
import 'example.dart';
import 'register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'session.dart';
import 'login.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SessionProvider(),
      child: MyApp(),
    ),
  );
}
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: LoginPage(),
//     );
//   }
// }




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SessionProvider(),
      child: MaterialApp(
        title: 'Your App',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),  // Check session state here
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('token');

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    if (storedToken != null) {
      // If token exists, set it in the session provider
      sessionProvider.register(storedToken);

      // Navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(username: 'Username')),  // You can retrieve the username as needed
      );
    } else {
      // If no token, redirect to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Splash Screen')),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
