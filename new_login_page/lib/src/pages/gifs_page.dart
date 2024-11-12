import 'package:flutter/material.dart';

class GifVideoPage extends StatelessWidget {
  const GifVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Gif Page"),
        ),
        body: Center(
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/gifs/loading.gif',
            image: 'assets/gifs/loading.gif',
          ),
        ),
      ),
    );
  }
}

