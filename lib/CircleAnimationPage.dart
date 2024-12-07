import 'package:flutter/material.dart';
import 'dart:math';

class CircleAnimationPage extends StatefulWidget {
  const CircleAnimationPage({super.key});

  @override
  State<CircleAnimationPage> createState() => _CircleAnimationPageState();
}

class _CircleAnimationPageState extends State<CircleAnimationPage> {
  final List<bool> _isClicked = [false, false, false, false, false];
  final List<double> _circleSizes = List.filled(5, 60.0); // Original size
  final List<Color> _circleColors =
      List.filled(5, Colors.blue); // Original color
  final double enlargedSize = 200.0; // 5x the original size
  final double normalSize = 60.0;
  final Duration shrinkDuration = const Duration(seconds: 2); // Slow shrink

  /// Handles the animation and color update.
  void _animateCircle(int index) {
    setState(() {
      // Enlarge the circle and set it to black
      _circleSizes[index] = enlargedSize;
      _circleColors[index] = Colors.black;
    });

    // Shrink the circle back after the enlarging finishes
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _circleSizes[index] = normalSize; // Reset to original size
        _circleColors[index] = Colors.black; // Keep it black
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle Animation'),
      ),
      body: Stack(
        children: List.generate(5, (index) {
          return Align(
            alignment: _circleAlignment(index),
            child: GestureDetector(
              onTap: () => _animateCircle(index),
              child: AnimatedContainer(
                duration: _circleSizes[index] == normalSize
                    ? shrinkDuration // Slow shrinking
                    : const Duration(milliseconds: 500), // Fast enlarging
                curve: _circleSizes[index] == normalSize
                    ? Curves.easeOut // Smooth shrinking
                    : Curves.easeInOut, // Smooth enlarging
                width: _circleSizes[index],
                height: _circleSizes[index],
                decoration: BoxDecoration(
                  color: _circleColors[index],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// Aligns the circles in fixed positions
  Alignment _circleAlignment(int index) {
    switch (index) {
      case 0:
        return const Alignment(-0.6, -0.5); // Top-left
      case 1:
        return const Alignment(0.6, -0.5); // Top-right
      case 2:
        return const Alignment(0.0, 0.0); // Center
      case 3:
        return const Alignment(-0.6, 0.5); // Bottom-left
      case 4:
        return const Alignment(0.6, 0.5); // Bottom-right
      default:
        return Alignment.center; // Default center
    }
  }
}
