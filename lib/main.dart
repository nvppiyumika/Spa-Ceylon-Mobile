import 'package:flutter/material.dart';
import 'Home.dart';
import 'Skin_care.dart'; // 👈 make sure this file name is correct
import 'components.dart';
import 'Mind_&_Body.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      home: MindAndBodyPage(), // 👈 This runs your SkinCare page
    );
  }
}
