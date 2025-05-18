import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

Widget topGreetingBar(String userName) {
  final user = FirebaseAuth.instance.currentUser;
  final userName = user?.displayName ?? 'User';
  return Container(
    height: 80,
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color.fromRGBO(191, 155, 67, 1),
          Color.fromRGBO(217, 182, 106, 1),
          Color.fromRGBO(191, 155, 67, 1),
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
                text: 'ආයුබෝවන් ',
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
