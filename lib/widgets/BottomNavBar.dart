import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Color selectedColor;
  final Color unselectedColor;
  final List<Color> gradientColors;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.black54,
    this.gradientColors = const [
      Color.fromRGBO(191, 155, 67, 1),
      Color.fromRGBO(217, 182, 106, 1),
      Color.fromRGBO(191, 155, 67, 1),
    ],
  });

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
          onTap: onItemTapped,
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
