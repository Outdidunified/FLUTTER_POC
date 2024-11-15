import 'package:flutter/material.dart';
import 'package:new_animation_proj/screens/home.dart';
import 'package:new_animation_proj/screens/sandbox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage()
    );
  }
}
