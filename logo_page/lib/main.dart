import 'package:flutter/material.dart';
import 'package:logo_oage/screen/location_logo.dart';
import 'package:logo_oage/screen/second_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationLogo(),
    );
  }
}
