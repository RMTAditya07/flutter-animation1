import 'package:flutter/material.dart';

class ImageAnimationPage extends StatefulWidget {
  const ImageAnimationPage({super.key});

  @override
  State<ImageAnimationPage> createState() => _ImageAnimationPageState();
}

class _ImageAnimationPageState extends State<ImageAnimationPage> {
  final List<bool> _isClicked = [false, false, false, false, false];
  final List<double> _imageSizes = List.filled(5, 60.0); // Original size
  final double enlargedSize = 300.0; // 5x the original size
  final double normalSize = 60.0;
  final Duration shrinkDuration = const Duration(seconds: 2); // Slow shrink

  /// Handles the animation of image size.
  void _animateImage(int index) {
    setState(() {
      // Enlarge the image
      _imageSizes[index] = enlargedSize;
    });

    // Shrink the image back after the enlarging finishes
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _imageSizes[index] = normalSize; // Reset to original size
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Animation'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => _animateImage(index),
              child: AnimatedContainer(
                duration: _imageSizes[index] == normalSize
                    ? shrinkDuration // Slow shrinking
                    : const Duration(milliseconds: 500), // Fast enlarging
                curve: _imageSizes[index] == normalSize
                    ? Curves.easeOut // Smooth shrinking
                    : Curves.easeInOut, // Smooth enlarging
                width: _imageSizes[index],
                height: _imageSizes[index],
                child: Image.asset(
                  'assets/image${index + 1}.png', // Replace with your image paths
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
