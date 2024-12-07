import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAnimationPage extends StatefulWidget {
  const SvgAnimationPage({super.key});

  @override
  State<SvgAnimationPage> createState() => _SvgAnimationPageState();
}

class _SvgAnimationPageState extends State<SvgAnimationPage> {
  final List<bool> _isClicked = [
    false,
    false,
    false,
    false,
    false
  ]; // Track which hearts are clicked
  final List<double> _svgSizes = List.filled(5, 60.0); // Original size
  final double enlargedSize = 300.0; // 5x the original size
  final double normalSize = 60.0;
  final Duration shrinkDuration = const Duration(seconds: 2); // Slow shrink

  final int maxClickLimit =
      4; // Number of clicks allowed before highlighting extra hearts
  bool _isSubmitClicked = false; // Track if submit button was clicked

  // Handles SVG animation, color change, and staying black after click
  void _animateSvg(int index) {
    setState(() {
      // Toggle the clicked state to black and enlarge the SVG
      if (!_isClicked[index]) {
        _isClicked[index] = true;
        _svgSizes[index] = enlargedSize;
      }
    });

    // Shrink back to normal size after a delay (slow shrink)
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (_isClicked[index]) {
          _svgSizes[index] = normalSize; // Reset size after click
        }
      });
    });
  }

  // Handle the submit logic
  void _submit() {
    setState(() {
      _isSubmitClicked = true; // Mark the submit button as clicked
    });

    // Highlight the 5th heart in red if more than 4 hearts are clicked
    if (_isClicked.where((clicked) => clicked).length > maxClickLimit) {
      // Find the first unclicked heart (the 5th one)
      int extraHeartIndex = _isClicked.indexOf(false);
      if (extraHeartIndex != -1) {
        setState(() {
          _isClicked[extraHeartIndex] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Animation'),
      ),
      body: Center(
        child: Stack(
          children: [
            // Centered Row of SVGs
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => _animateSvg(index),
                    child: AnimatedContainer(
                      duration: _svgSizes[index] == normalSize
                          ? shrinkDuration // Slow shrinking
                          : const Duration(milliseconds: 500), // Fast enlarging
                      curve: _svgSizes[index] == normalSize
                          ? Curves.easeOut // Smooth shrinking
                          : Curves.easeInOut, // Smooth enlarging
                      width: _svgSizes[index],
                      height: _svgSizes[index],
                      child: SvgPicture.asset(
                        'assets/heart${index + 1}.svg', // Replace with your SVG paths
                        colorFilter: ColorFilter.mode(
                          _isClicked[index]
                              ? (_isSubmitClicked && index == 4
                                  ? Colors
                                      .red // Turn the 5th heart red after submit
                                  : Colors.black) // Otherwise black
                              : Colors.blue, // Default color when not clicked
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            // Fixed Submit Button at the bottom right
            Positioned(
              bottom: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
