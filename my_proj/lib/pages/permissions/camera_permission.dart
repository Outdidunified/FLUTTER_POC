// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:camera/camera.dart';
//
// class CameraPermission extends StatefulWidget {
//   const CameraPermission({super.key});
//
//   @override
//   State<CameraPermission> createState() => _CameraPermissionState();
// }
//
// class _CameraPermissionState extends State<CameraPermission> {
//   bool _isCameraPermissionGranted = false;
//   late CameraController _cameraController;
//   late List<CameraDescription> _cameras;
//   bool _isCameraInitialized = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkPermissionStatus();
//   }
//
//   // Check camera permission status
//   void _checkPermissionStatus() async {
//     PermissionStatus status = await Permission.camera.status;
//
//     if (status == PermissionStatus.granted) {
//       setState(() {
//         _isCameraPermissionGranted = true;
//       });
//     } else {
//       setState(() {
//         _isCameraPermissionGranted = false;
//       });
//     }
//   }
//
//   // Request camera permission
//   void _requestPermission() async {
//     PermissionStatus status = await Permission.camera.request();
//     setState(() {
//       _isCameraPermissionGranted = status.isGranted;
//     });
//
//     if (_isCameraPermissionGranted) {
//       _initializeCamera(); // Initialize camera if permission is granted
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Camera permission denied')),
//       );
//     }
//   }
//
//   // Initialize the camera
//   void _initializeCamera() async {
//     _cameras = await availableCameras();
//     _cameraController = CameraController(
//       _cameras[0],
//       ResolutionPreset.high,
//     );
//
//     try {
//       await _cameraController.initialize();
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     } catch (e) {
//       print('Error initializing camera: $e');
//     }
//   }
//
//   // Start the camera preview
//   Widget _buildCameraPreview() {
//     if (!_isCameraInitialized) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     return CameraPreview(_cameraController);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Camera Permission')),
//       body: Column(
//         children: [
//           ListTile(
//             leading: Icon(Icons.camera),
//             title: Text("Camera Permission"),
//             onTap: () {
//               if (_isCameraPermissionGranted) {
//                 _initializeCamera(); // Open camera if permission is granted
//               } else {
//                 _requestPermission(); // Request permission
//               }
//             },
//           ),
//           _buildCameraPreview(), // Show camera preview
//         ],
//       ),
//     );
//   }
// }
