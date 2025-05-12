import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/screens/Home.dart';
import 'package:spa_ceylon_mobile/screens/Login.dart';
import 'package:spa_ceylon_mobile/screens/Messages.dart';
import 'package:spa_ceylon_mobile/screens/Promotions.dart';
import 'package:spa_ceylon_mobile/screens/Cart.dart';
import 'package:spa_ceylon_mobile/screens/Profile.dart';
import 'package:spa_ceylon_mobile/screens/Baby_Care.dart';
import 'package:spa_ceylon_mobile/screens/Skin%20care.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/baby_care': (context) => Baby_Care(),
        '/skin_wellness': (context) => Skin_care(),
        '/messages': (context) => const MessagesPage(),
        '/promotions': (context) => const PromotionsPage(),
        '/cart': (context) => CartPage(),
        '/profile': (context) => const ProfilePage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Home(),
        );
      },
    );
  }
}
