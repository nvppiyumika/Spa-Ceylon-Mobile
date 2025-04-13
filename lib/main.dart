import 'package:flutter/material.dart';
import 'package:spaceylon/Home.dart';
import 'package:spaceylon/login_page.dart';
import 'package:spaceylon/register_page.dart';

void main() {
  runApp( MyApp());

  
}class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
         '/login_page': (context) => LoginPage(),
      },
    );
  }
}