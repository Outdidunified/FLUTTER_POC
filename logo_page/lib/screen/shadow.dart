import 'package:flutter/material.dart';
import 'dart:math';  // Import the math library
class Shadow extends StatefulWidget {
  const Shadow({super.key});

  @override
  State<Shadow> createState() => _ShadowState();
}

class _ShadowState extends State<Shadow> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _shadowBlurAnimation;
  late Animation<double> _shadowSpreadAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for size
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);

    // Animation for expanding/shrinking circle size
    _sizeAnimation = Tween<double>(begin: 200.0, end: 250.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Animation for expanding/shrinking shadow blur radius
    _shadowBlurAnimation = Tween<double>(begin: 25.0, end: 50.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Animation for expanding/shrinking shadow spread radius
    _shadowSpreadAnimation = Tween<double>(begin: 0, end: 10.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..rotateX(pi / 2.1)  // Rotating around X-axis to simulate 3D rotation
                ..translate(0.0, 100.0),  // Adjust the translation to make it visible in the center
              origin: Offset(0, 250),  // Set origin at the center of the container (for correct rotation)
              child: Container(
                // child: ContinuousWaterDrops(),
                width: _sizeAnimation.value,
                height: _sizeAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,  // Set the color of the container to make it visible
                  boxShadow: [
                    BoxShadow(
                      blurRadius: _shadowBlurAnimation.value,  // Dynamic blur radius for the shadow
                      spreadRadius: _shadowSpreadAnimation.value,  // Dynamic spread radius for the shadow
                      color: Colors.grey.withOpacity(0.6),  // Shadow color and opacity
                      offset: Offset(10, 30),  // Shadow offset to simulate light direction
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
