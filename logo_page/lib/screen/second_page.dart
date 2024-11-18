import 'package:flutter/material.dart';
import 'dart:math';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  State<LogoPage> createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  late AnimationController _shadowController;
  late Animation<double> _shadowAnimation;

  List<Offset> _drops = [];

  @override
  void initState() {
    super.initState();

    // Bouncing animation for the location icon
    _bounceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Faster bounce speed
    )..repeat(reverse: true); // Creates a continuous bounce effect

    _bounceAnimation = Tween<double>(
      begin: 0.0, // Initial position
      end: -30.0, // Increased bounce height to allow the icon to touch the shadow at the bottom
    ).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );


    // Shadow animation (when the icon is at the bottom)
    _shadowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _shadowController.dispose();
    super.dispose();
  }

  // Generate drops when the location icon touches the shadow
  void _generateDrops() {
    setState(() {
      _drops.clear(); // Clear previous drops
      Random random = Random();
      for (int i = 0; i < 10; i++) {
        // Generate random position for drops around the shadow
        double dx = random.nextDouble() * 40 - 20; // Random offset for X
        double dy = random.nextDouble() * 20 + 10; // Random offset for Y, drops go upward
        _drops.add(Offset(dx, dy));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouncing location icon
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                // Check if the icon is near the bottom and trigger the shadow and drops
                // if (_bounceAnimation.value < -33) {  // Trigger when the icon touches the bottom
                  // Using addPostFrameCallback to schedule _generateDrops() after build phase
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      _shadowController.forward(); // Trigger shadow expansion
                      _generateDrops(); // Generate drops when the icon touches the shadow
                    }
                  });
                // }
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 150,
                  ),
                );
              },
            ),
            // SizedBox(height: 10),
            // Shadow effect (growing circle beneath the icon)
            AnimatedBuilder(
              animation: _shadowController,
              builder: (context, child) {
                return Container(
                  width: _shadowController.value * 30 + 70, // Shadow size grows
                  height: _shadowController.value * 30 + 70, // Shadow size grows
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
            SizedBox(height: 50),
            // Drop animations (small drops around the shadow)
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // Drops around the icon when it touches the shadow
                ..._drops.map((dropPosition) {
                  return Positioned(
                    left: dropPosition.dx,
                    top: dropPosition.dy,
                    child: Drop(),
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Drop widget (small blue circle, simulating water drops)
class Drop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10, // Size of the drops
      height: 10, // Size of the drops
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
    );
  }
}
