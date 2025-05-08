import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/Login.dart';
import 'package:spa_ceylon_mobile/home.dart';
import 'package:spa_ceylon_mobile/messages.dart';
import 'package:spa_ceylon_mobile/Promotions.dart';
import 'package:spa_ceylon_mobile/cart.dart';
import 'package:spa_ceylon_mobile/Profile.dart';
import 'package:spa_ceylon_mobile/Baby_Care.dart';
import 'package:spa_ceylon_mobile/Skin care.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Set the initial route to the Login page
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/baby_care': (context) => Baby_Care(),
        '/skin_wellness': (context) => Skin_care(),
        '/messages': (context) => MessagesPage(),
        '/promotions': (context) => PromotionsPage(),
        '/cart': (context) => CartPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}