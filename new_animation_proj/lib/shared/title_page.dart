import 'package:flutter/material.dart';

class TitlePage extends StatelessWidget {

final String text;

const TitlePage({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold
    ),);
  }
}
