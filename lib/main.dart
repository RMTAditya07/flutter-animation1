import 'package:anime/ImageAnimationPage.dart';
import 'package:flutter/material.dart';
import 'package:anime/CircleAnimationPage.dart';
import 'package:anime/SvgAnimationPage3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SVG Animation',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SvgAnimationPage3(),
    );
  }
}
