import 'package:flutter/material.dart';
import 'Home.dart';
import 'Skin_care.dart';
import 'components.dart';
import 'Mind_&_Body.dart';
import 'Homeware.dart';
import 'SingleProduct.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      home: SingleProductPage(),
    );
  }
}
