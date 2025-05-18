import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spa_ceylon_mobile/screens/Home.dart';
import 'package:spa_ceylon_mobile/screens/Login.dart';
import 'package:spa_ceylon_mobile/screens/Messages.dart';
import 'package:spa_ceylon_mobile/screens/Profile.dart';
import 'package:spa_ceylon_mobile/screens/Cart.dart';
import 'package:spa_ceylon_mobile/screens/Promotions.dart';
import 'package:spa_ceylon_mobile/screens/Address__Book.dart';
import 'package:spa_ceylon_mobile/screens/Edit_Profile.dart';
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
      initialRoute: '/login', // Set the initial route to the Login page
      routes: {
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/messages': (context) => MessagesPage(),
        '/promotions': (context) => PromotionsPage(),
        '/cart': (context) => CartPage(),
        '/profile': (context) => ProfilePage(),
        '/account_information': (context) => EditProfilePage(),
        '/address_book': (context) => AddressBook(),
      },
    );
  }
}
