import 'package:flutter/material.dart';
import 'package:new_animation_proj/models/Trip.dart';
import 'package:new_animation_proj/screens/detail_page.dart';

class Triplist extends StatefulWidget {
  const Triplist({super.key});

  @override
  State<Triplist> createState() => _TriplistState();
}

class _TriplistState extends State<Triplist> {
   List <Widget> _tripTiles = [];
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _addLists();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  void _addLists(){
    List<Trip> _trips=[
      Trip(title: 'Beach Paradise', price: '350', nights: '3', img: 'beach.png'),
      Trip(title: 'City Break', price: '400', nights: '5', img: 'city.png'),
      Trip(title: 'Ski Adventure', price: '750', nights: '2', img: 'ski.png'),
      Trip(title: 'Space Blast', price: '600', nights: '4', img: 'space.png'),];
_trips.forEach((Trip trip){
  _tripTiles.add(_buildTrip(trip));
  _listkey.currentState?.insertItem(_tripTiles.length-1);
});

  }
  
  Widget _buildTrip(Trip trip){
    return ListTile(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(trip:trip)));
      },
      contentPadding: EdgeInsets.all(25),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${trip.nights} nights', style: TextStyle(
            color: Colors.lightBlue,fontSize: 14,fontWeight: FontWeight.bold
          ),),
          Text(trip.title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20),),
        ],
      ),
      leading: ClipRect(
        child: Hero(
          tag: "location-tag-${trip.img}",
            child: Image.asset("assets/images/${trip.img}", height: 50,)),
      ),
      trailing: Text("\$${trip.price},")
    );
  }
  
  Tween<Offset> _offset = Tween(begin: Offset(1,0), end: Offset(0,0));
  @override
  Widget build(BuildContext context) {
    return AnimatedList(
         key: _listkey,
         initialItemCount: _tripTiles.length,
        itemBuilder: (context, index, animation){
           return SlideTransition(
             child: _tripTiles[index],
               position: animation.drive(_offset)
           );
        },
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return ListView.builder(
//     key: _listkey,
//     itemCount: _tripTiles.length,
//     itemBuilder: (context, index){
//       return _tripTiles[index];
//     },
//   );
// }
// }