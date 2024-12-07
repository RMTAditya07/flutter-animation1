import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgAnimationPage3 extends StatefulWidget {
  const SvgAnimationPage3({super.key});

  @override
  State<SvgAnimationPage3> createState() => _SvgAnimationPageState();
}

class _SvgAnimationPageState extends State<SvgAnimationPage3> {
  final List<bool> _isClicked = [false, false, false, false, false];
  final double enlargedSize = 300.0;
  final double normalSize = 100.0;
  final List<double> _svgSizes = List.filled(5, 100.0);
  final Duration shrinkDuration = const Duration(milliseconds: 700);

  int? _currentEnlargedIndex;
  final int maxClickLimit = 3;
  bool _isSubmitClicked = false;

  void _animateSvg(int index) {
    setState(() {
      _isClicked[index] = true;

      if (_currentEnlargedIndex != null && _currentEnlargedIndex != index) {
        int previousIndex = _currentEnlargedIndex!;
        _currentEnlargedIndex = index;

        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _svgSizes[previousIndex] = normalSize;
          });
        });
      }

      _svgSizes[index] = enlargedSize;
      _currentEnlargedIndex = index;
    });
  }

  void _submit() {
    setState(() {
      _isSubmitClicked = true;
    });

    int clickedCount = _isClicked.where((clicked) => clicked).length;

    if (clickedCount > maxClickLimit) {
      for (int i = maxClickLimit; i < _isClicked.length; i++) {
        if (_isClicked[i]) {
          _highlightExtraApple(i);
        }
      }
    }

    // Start highlighting the correct apples after extras are highlighted
    Future.delayed(const Duration(milliseconds: 700), () {
      _highlightCorrectApplesSequentially();
    });
  }

  void _highlightExtraApple(int index) {
    setState(() {
      _svgSizes[index] = enlargedSize; // Enlarge the extra SVG
    });

    // Shrink back to normal size after a delay (slow shrink)
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _svgSizes[index] = normalSize; // Shrink to normal size
      });
    });
  }

  void _highlightCorrectApplesSequentially() async {
    for (int i = 0; i < maxClickLimit; i++) {
      print('Highlighting apple $i'); // Debugging print
      await Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          // Zoom out the previous apple if any
          if (_currentEnlargedIndex != null) {
            _svgSizes[_currentEnlargedIndex!] = normalSize;
            print('Zoomed out apple $_currentEnlargedIndex'); // Debugging print
          }

          // Zoom in the current apple
          _svgSizes[i] = enlargedSize;
          _currentEnlargedIndex = i;
          print('Zoomed in apple $i'); // Debugging print
        });
      });
    }

    // Zoom out the last highlighted apple after the sequence
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        if (_currentEnlargedIndex != null) {
          _svgSizes[_currentEnlargedIndex!] = normalSize;
          _currentEnlargedIndex = null; // Reset after showing the sequence
          print('Reset after showing sequence'); // Debugging print
        }
      });
    });
  }

  Color _getAppleColor(int index) {
    if (_isSubmitClicked && _isClicked[index] && index >= maxClickLimit) {
      return Colors.black; // Extra apples turn black
    } else if (_isClicked[index]) {
      return Colors.red; // Clicked apples turn red
    } else {
      return const Color.fromARGB(255, 102, 111, 118); // Default grey
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Animation & Evaluation'),
      ),
      body: Stack(
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => _animateSvg(index),
                  child: AnimatedContainer(
                    duration: _svgSizes[index] == normalSize
                        ? shrinkDuration // Slow shrinking
                        : const Duration(milliseconds: 300), // Fast enlarging
                    curve: _svgSizes[index] == normalSize
                        ? Curves.bounceOut
                        : Curves.easeInOut,
                    // curve: Curves.bounceOut,
                    width: _svgSizes[index],
                    height: _svgSizes[index],
                    child: SvgPicture.asset(
                      'assets/apple${index + 1}.svg',
                      colorFilter: ColorFilter.mode(
                        _getAppleColor(index),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
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
    );
  }
}
