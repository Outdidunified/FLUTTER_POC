import 'package:flutter/material.dart';

class ResponsivePage extends StatelessWidget {
  final Widget mobile;
  final Widget tab;


  const ResponsivePage({super.key, required this.mobile, required this.tab});

  // const ResponsivePage({super.key, required this.mobile, required this.tab});
  // double screenWidth = MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(builder: (context, snapshot) {
      if(screenWidth < 600) {
        return mobile;
      }else{
        return tab;
      }

    });
  }
}
