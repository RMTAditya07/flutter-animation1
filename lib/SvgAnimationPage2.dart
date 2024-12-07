import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAnimationPage2 extends StatefulWidget {
  const SvgAnimationPage2({super.key});

  @override
  State<SvgAnimationPage2> createState() => _SvgAnimationPageState();
}

class _SvgAnimationPageState extends State<SvgAnimationPage2> {
  final List<double> _svgSizes = List.filled(5, 60.0); // Original size
  final double enlargedSize = 300.0; // Enlarged size
  final double normalSize = 60.0;

  int? _currentEnlargedIndex; // Tracks the currently enlarged heart

  // Handles SVG animation, enlarging current and shrinking the previous one
  void _animateSvg(int index) {
    setState(() {
      if (_currentEnlargedIndex != index) {
        // Shrink the previously enlarged heart, if any
        if (_currentEnlargedIndex != null) {
          _svgSizes[_currentEnlargedIndex!] = normalSize;
        }

        // Enlarge the currently clicked heart
        _svgSizes[index] = enlargedSize;

        // Update the current enlarged index
        _currentEnlargedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Animation with Bounce'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () => _animateSvg(index),
              child: AnimatedContainer(
                duration: Duration(milliseconds: _svgSizes[index] == normalSize ? 700 : 300),
                curve: _svgSizes[index] == normalSize ? Curves.bounceOut : Curves.easeInOut,
                width: _svgSizes[index],
                height: _svgSizes[index],
                child: SvgPicture.asset(
                  'assets/heart${index + 1}.svg', // Replace with your SVG paths
                  colorFilter: const ColorFilter.mode(
                    Colors.black, // Default black color
                    BlendMode.srcIn,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
