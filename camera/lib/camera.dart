// import 'package:flutter/material.dart';
//
// class CameraScreen extends StatefulWidget {
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late List<CameraDescription> _cameras;
//   bool _isInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeCamera();
//   }
//
//   Future<void> _initializeCamera() async {
//     // Get the list of available cameras
//     _cameras = await availableCameras();
//
//     // Select the first camera (back camera)
//     _controller = CameraController(
//       _cameras[0],  // Select the first available camera
//       ResolutionPreset.high,
//     );
//
//     // Initialize the camera controller
//     await _controller.initialize();
//
//     setState(() {
//       _isInitialized = true;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isInitialized) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Camera Preview')),
//       body: Center(
//         child: CameraPreview(_controller),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // Take a picture and save it to a file
//           try {
//             XFile picture = await _controller.takePicture();
//             print("Picture taken: ${picture.path}");
//           } catch (e) {
//             print("Error taking picture: $e");
//           }
//         },
//         child: Icon(Icons.camera_alt),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
