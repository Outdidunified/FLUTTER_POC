import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // Import Firebase Analytics
import 'package:new_animation_proj/shared/title_page.dart';
import 'package:new_animation_proj/shared/triplist.dart';

class HomePage extends StatelessWidget {
  // Use FirebaseAnalytics.instance to get the instance
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Log the screen view for the HomePage
    _logScreenView();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.fitWidth, // Adjusts the image to cover the entire container
            alignment: Alignment.topLeft,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            SizedBox(
              height: 160,
              child: TitlePage(text: 'Ninja Trips'),
            ),
            Flexible(child: Triplist())
          ],
        ),
      ),
    );
  }

  // Method to log screen view using Firebase Analytics
  // Method to log the screen view event
  void _logScreenView() {
    _analytics.logEvent(
      name: 'screen_view',
      parameters: {
        'screen_name': 'HomePage',  // The screen name you want to log
        'screen_class': 'HomePage', // The screen class or widget name
      },
    );
  }
}
