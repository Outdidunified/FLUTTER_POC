import 'package:flutter/material.dart';
import 'package:login/main.dart';
import 'package:login/src/pages/login.dart';
// import 'package:login/src/pages/homepage.dart';
// import 'package:login/src/pages/splash_screen.dart';  // Assuming you have a separate splash screen
import 'package:login/src/pages/example.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/loginpage':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/homepage':
        return MaterialPageRoute(builder: (_) => HomePage());
    // Add more routes as needed
      default:
        return MaterialPageRoute(

          builder: (_) => Scaffold(
            appBar: AppBar(title: Text('404')),
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
