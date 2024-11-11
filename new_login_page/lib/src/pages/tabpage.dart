import 'package:flutter/material.dart';
import 'package:login/src/pages/gifs_page.dart';
import 'package:login/src/pages/image_page.dart';
import 'package:login/src/pages/video_player_page.dart';
class Tabpage extends StatelessWidget {
  const Tabpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                  tabs:[
                  Tab(icon: Icon(Icons.image),),
                    Tab(icon: Icon(Icons.video_file_outlined),),
                    Tab(icon: Icon(Icons.gif),)
                  ]),
            ),
            body: TabBarView(
                children: [
                  ImageAlbumScreen(),
                  AssetVideoPlayerScreen(),
                  GifVideoPage()
                ]),
          )),
    );
  }
}
