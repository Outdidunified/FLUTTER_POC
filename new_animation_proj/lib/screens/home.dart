import 'package:flutter/material.dart';
import 'package:new_animation_proj/shared/title_page.dart';
import 'package:new_animation_proj/shared/triplist.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          padding: EdgeInsets.all(20),

        decoration: BoxDecoration(
            image: DecorationImage(

              image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.fitWidth, // Adjusts the image to cover the entire container
              alignment: Alignment.topLeft
          )
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              SizedBox(
                height: 160,
                child: TitlePage(text: 'Ninja Trips'),
              ),
              Flexible(
                  child: Triplist())
              //Sandbox(),
            ],
          )
      ),
    );
  }
}
