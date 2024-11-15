import 'package:flutter/material.dart';

class TitlePage extends StatelessWidget {

final String text;

const TitlePage({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        child: Text(text, style: TextStyle(
            color: Colors.white, fontSize: 37, fontWeight: FontWeight.bold
        ),),
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: 1),
        builder: (BuildContext context, double _val, child){
          return Opacity(
              opacity: _val,
            child: child,
          );
    },
    ) ;
  }
}
