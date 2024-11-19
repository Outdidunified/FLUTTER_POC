import 'package:flutter/material.dart';
import 'dart:math';  // For randomization of bubble drop movement

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
  bool _celebrationTriggered = false;

  @override
  void initState() {
    super.initState();

    // Animation controller for size, shadow blur, and shadow spread
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
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
    _shadowSpreadAnimation = Tween<double>(begin: 10.0, end: 30.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method to trigger celebration animation and water drops
  void triggerCelebration() {
    setState(() {
      _celebrationTriggered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Shadow circle container
                Container(
                  width: _sizeAnimation.value,
                  height: _sizeAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,  // Color of the container
                    boxShadow: [
                      BoxShadow(
                        blurRadius: _shadowBlurAnimation.value, // Dynamic blur
                        spreadRadius: _shadowSpreadAnimation.value, // Dynamic spread
                        color: Colors.grey.withOpacity(0.6), // Shadow color
                        offset: const Offset(10, 30), // Shadow offset direction
                      ),
                    ],
                  ),
                ),

                // Water drops animation
                Positioned.fill(
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    maxHeight: double.infinity,
                    child: ContinuousWaterDrops(
                      shrinkAnimationValue: _sizeAnimation.value, // Use size animation to trigger drops
                      celebrationTriggered: _celebrationTriggered, // Trigger drops on celebration
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // Button to trigger celebration (this can be replaced with any other event)
      floatingActionButton: FloatingActionButton(
        onPressed: triggerCelebration,
        backgroundColor: Colors.blue,
        child: Icon(Icons.star, color: Colors.white),
      ),
    );
  }
}

// Water drop animation widget
class ContinuousWaterDrops extends StatelessWidget {
  final double shrinkAnimationValue;
  final bool celebrationTriggered;

  const ContinuousWaterDrops({Key? key, required this.shrinkAnimationValue, required this.celebrationTriggered}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(20, (index) {
        if (!celebrationTriggered) {
          return SizedBox(); // No drops until celebration is triggered
        }

        // Generate random values for drops
        double angle = (2 * pi / 20) * index + Random().nextDouble() * pi;  // Random angle for dispersion
        double distance = 50 + (shrinkAnimationValue - 200) * 1.5;  // Distance based on shrinking animation

        double offsetX = cos(angle) * distance;  // Horizontal offset
        double offsetY = sin(angle) * distance;  // Vertical offset

        // The drops will expand and fade as they move outward
        return Positioned(
          left: 0, right: 0, top: 0, bottom: 0,
          child: Transform.translate(
            offset: Offset(offsetX, offsetY),
            child: Opacity(
              opacity: 1 - (shrinkAnimationValue - 200) / 50,  // Fade out with distance
              child: Container(
                width: 8 + (shrinkAnimationValue - 200) / 20,  // Expand as distance increases
                height: 8 + (shrinkAnimationValue - 200) / 20,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.7),  // Color of the drops
                  shape: BoxShape.circle,  // Round shape for drops
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
