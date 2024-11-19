import 'package:flutter/material.dart';
import 'dart:math';

class RotatingIconPage extends StatefulWidget {
  const RotatingIconPage({super.key});

  @override
  _RotatingIconPageState createState() => _RotatingIconPageState();
}

class _RotatingIconPageState extends State<RotatingIconPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for continuous rotation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Animation to rotate the icon within the circle
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2* pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform(
              // 3D rotation using Matrix4
              transform: Matrix4.identity()
                ..rotateX(_rotationAnimation.value) // Rotation around X axis
                ..rotateY(_rotationAnimation.value) // Rotation around Y axis
                ..rotateZ(_rotationAnimation.value), // Rotation around Z axis
              alignment: FractionalOffset.center,
              child: child,
            );
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.location_on,
                color: Colors.red,
                size: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
