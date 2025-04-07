// components.dart
import 'package:flutter/material.dart';

Widget topGreetingBar(String userName) {
  return Container(
    height: 80,
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(191, 155, 67, 1),
          Color.fromRGBO(217, 182, 106, 1),
          Color.fromRGBO(191, 155, 67, 1)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 18, color: Colors.black),
            children: [
              TextSpan(
                text: 'AYUBOWAN ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '$userName.'),
            ],
          ),
        ),
        Icon(Icons.notifications, size: 26, color: Colors.black),
      ],
    ),
  );
}

Widget bottomNavBar(int selectedIndex, Function(int) onTap) {
  List<Map<String, dynamic>> items = [
    {'icon': Icons.home_outlined, 'label': 'Home'},
    {'icon': Icons.chat_bubble_outline, 'label': 'Inbox'},
    {'icon': Icons.percent, 'label': 'Promotions'},
    {'icon': Icons.shopping_cart_outlined, 'label': 'Cart'},
    {'icon': Icons.person_outline, 'label': 'Profile'},
  ];

  return Container(
    height: 75,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(191, 155, 67, 1),
          Color.fromRGBO(217, 182, 106, 1),
          Color.fromRGBO(191, 155, 67, 1)
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (index) {
        bool isSelected = selectedIndex == index;
        return GestureDetector(
          onTap: () => onTap(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                items[index]['icon'],
                color: Colors.black,
              ),
              SizedBox(height: 4),
              Text(
                items[index]['label'],
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              )
            ],
          ),
        );
      }),
    ),
  );
}
