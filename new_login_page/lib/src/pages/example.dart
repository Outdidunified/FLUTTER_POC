import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/session.dart';
import 'login.dart';
import './video_player_page.dart';
import './image_page.dart';
import './gifs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Handle logout function
  void _handleLogout() async {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);

    // Clear the token from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token

    // Clear the session in the SessionProvider
    sessionProvider.logout(); // Log out from the provider session

    // Navigate back to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the username from SessionProvider

    final sessionUsername = Provider.of<SessionProvider>(context).username;
    print("username:$sessionUsername");

    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _handleLogout, // Call logout when the user presses the button
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors:[
                  Color(0xffB81736),
                  Color(0xff281537)
                ]
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Hello," "$sessionUsername! Welcome to the newpage",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            // SizedBox(height: 10,),
            // Image.network("https://picsum.photos/250?image=9"),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AssetVideoPlayerScreen()));
                    },
      child:Text("Click here to play the videos", style: TextStyle(color: Colors.white, ),)),
                SizedBox(width: 10,),
                Icon(Icons.video_file, color: Colors.white,),

              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>ImageAlbumScreen()));
                  },
                  child: Text("Click here to see the images", style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 10,),

                Icon(Icons.image, color: Colors.white,),

              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>GifVideoPage()));
                  },
                  child: Text("Click here to see the gifs", style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 10,),

                Icon(Icons.gif_box_outlined, color: Colors.white,),

              ],
            )
          ],
        ),
      ),
    );
  }
}
