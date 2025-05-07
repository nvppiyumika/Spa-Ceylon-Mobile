import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/Login.dart';
import 'package:spa_ceylon_mobile/home.dart';
import 'package:spa_ceylon_mobile/messages.dart';
import 'package:spa_ceylon_mobile/Promotions.dart';
import 'package:spa_ceylon_mobile/cart.dart';
import 'package:spa_ceylon_mobile/Profile.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Login());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    setState(() {
      _selectedIndex = selectedIndex;
      _pageController.jumpToPage(selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            //Center(child: Text("Test Page")),
            WellnessHomePage(),
            MessagesPage(),
            PromotionsPage(),
            CartPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ), // Use the BottomNavBar widget
      ),
    );
  }
}
