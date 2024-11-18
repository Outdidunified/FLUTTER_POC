import 'package:flutter/material.dart';

class Droppage extends StatefulWidget {
  const Droppage({super.key});

  @override
  State<Droppage> createState() => _DroppageState();
}

class _DroppageState extends State<Droppage> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green
      ),
    );
  }
}


