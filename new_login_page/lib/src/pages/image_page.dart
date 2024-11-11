import 'package:flutter/material.dart';

class ImageAlbumScreen extends StatelessWidget {
  // List of image asset paths
  final List<String> imagePaths = [
    'assets/images/logo_test.jpg',
    "https://picsum.photos/250?image=9",
    'assets/images/logo_test.jpg',
    "https://picsum.photos/250?image=9",
    'assets/images/logo_test.jpg',
    "https://picsum.photos/250?image=9",
    'assets/images/logo_test.jpg',
    "https://picsum.photos/250?image=9",
    'assets/images/logo_test.jpg',
    "https://picsum.photos/250?image=9",
    'assets/images/logo_test.jpg',
    "https://picsum.photos/250?image=9",
    "https://picsum.photos/250?image=9"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Album'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns in the grid
          crossAxisSpacing: 8.0, // Horizontal space between images
          mainAxisSpacing: 8.0, // Vertical space between images
        ),
        itemCount: imagePaths.length, // Total number of images
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Optionally, handle image tap
              print('Image $index tapped');
            },
            child: Image.network(
              imagePaths[index], // Load image from assets
              fit: BoxFit.cover, // Fit the image within the grid tile
            ),
          );
        },
      ),
    );
  }
}
//
// void main() {
//   runApp(MaterialApp(
//     home: ImageAlbumScreen(),
//   ));
// }
