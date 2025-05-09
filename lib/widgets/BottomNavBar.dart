// ignore: file_names
import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/main.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Color selectedColor;
  final Color unselectedColor;
  final List<Color> gradientColors;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.black54,
    this.gradientColors = const [
      Color.fromRGBO(191, 155, 67, 1),
      Color.fromRGBO(217, 182, 106, 1),
      Color.fromRGBO(191, 155, 67, 1),
    ],
  });

  void _onNavTapped(BuildContext context, int index) {
  // List of route paths
 List<String> routes = [
    '/home',
    '/messages',
    '/promotions',
    '/cart',
    '/profile',
  ];

  // Navigate to the route corresponding to the selected index
  if (index >= 0 && index < routes.length) {
    Navigator.pushReplacementNamed(context, routes[index]);
  }
}

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        height: 60, // Set to standard BottomNavigationBar height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: selectedIndex,
          onTap: (index) => _onNavTapped(context, index), // Call the navigation logic
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.percent),
              label: 'Promotions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
