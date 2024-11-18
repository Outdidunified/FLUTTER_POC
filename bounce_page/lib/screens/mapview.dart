// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> {
//   late WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize the WebView plugin for Android and iOS.
//     WebView.platform = SurfaceAndroidWebView();  // For Android platform
//     // You can also call `WebView.platform = SurfaceIOSWebView();` if you need it for iOS
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Google Maps WebView'),
//       ),
//       body: WebView(
//         initialUrl: 'https://www.google.com/maps',  // Google Maps URL
//         onWebViewCreated: (WebViewController webViewController) {
//           _controller = webViewController;
//         },
//         javascriptMode: JavascriptMode.unrestricted, // Enable JavaScript for interactive maps
//       ),
//     );
//   }
// }
