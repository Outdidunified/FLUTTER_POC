import 'package:flutter/material.dart';

class LocationLogo extends StatefulWidget {
  const LocationLogo({super.key});

  @override
  State<LocationLogo> createState() => _LocationLogoState();
}

class _LocationLogoState extends State<LocationLogo> with SingleTickerProviderStateMixin {
  double _linePosition = -1.0;
  double _toplinePosition = -1.0; // Initial position of the yellow lines.
  double _rightLinePosition = -1.0; // Initial position (off-screen to the right)

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation; // For sliding the image
  late Animation<double> _fadeAnimation;  // Optional fade animation
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))
      ..forward(); // Start animation automatically

    // Slide animation for the image
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1, 0), // Start off-screen to the left
      end: Offset(0, 0),    // Move to the center
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Fade animation (optional)
    _fadeAnimation = Tween<double>(
      begin: 0.0, // Fully transparent
      end: 1.0,   // Fully visible
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isAnimating = true;
        _linePosition = 1.0;
        _rightLinePosition = -1.0;
        _toplinePosition = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Animate the background image using SlideTransition
            SlideTransition(
              position: _slideAnimation,

              child: FadeTransition(
                opacity: _fadeAnimation, // Optional fade effect
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    "assets/location.webp",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Yellow lines animation
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              top: 100, // The line stays at the top
              left: _toplinePosition * 100, // Animate the line from left to right
              right: 0,
              child: Container(
                height: 20,
                color: Colors.yellow,
              ),
            ),
            // Vertical yellow line coming from the right
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              right: 60,
              top: 0,
              bottom: _linePosition * 100,
              child: Container(
                width: 20,
                color: Colors.yellow,
              ),
            ),
            // Horizontal yellow line coming from the bottom
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              left: 0,
              right: _toplinePosition * 100,
              bottom: 100,
              child: Container(
                height: 20,
                color: Colors.yellow,
              ),
            ),
            // Vertical yellow line coming from the left
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              left: 60,
              top: _linePosition * 100,
              bottom: 0,
              child: Container(
                width: 20,
                color: Colors.yellow,
              ),
            ),
            // Red location icon at the center
            AnimatedPositioned(
              duration: Duration(seconds: 1),
              top: _linePosition * 100 + 150,
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

