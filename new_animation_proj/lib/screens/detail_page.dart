import 'package:flutter/material.dart';
import 'package:new_animation_proj/models/Trip.dart';
import 'package:new_animation_proj/shared/heart.dart';
import 'package:ipsum/ipsum.dart';

class DetailPage extends StatelessWidget {
  final Trip trip;

  const DetailPage({super.key, required this.trip});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:<Widget>[
            ClipRect(
              child: Hero(
                tag: "location-tag-${trip.img}",
                  child: Image.asset("assets/images/${trip.img}", height: 360, fit: BoxFit.cover, alignment: Alignment.topCenter,)),
            ),
        SizedBox(height: 10,),
            ListTile(
              title: Text(
                trip.title, style: TextStyle(fontSize:20, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Text("${trip.nights} night stay for only \$ ${trip.price}", style: TextStyle(
                color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold
              ),),
              trailing: HeartPage()
            ),
              Padding(
                child: Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, height: 1.4),),
                  padding: EdgeInsets.all(18)
              )
          ],
        ),
      ),
    );

  }
}

