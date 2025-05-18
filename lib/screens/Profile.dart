import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart';
import 'package:spa_ceylon_mobile/services/authService.dart';
import 'package:spa_ceylon_mobile/screens/Login.dart'; // Ensure this matches your Login page path

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  final picker = ImagePicker();
  final AuthService _authService = AuthService(); // Add AuthService instance

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  Future<void> _showLogoutConfirmation() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _authService.signOut(); // Call signOut from AuthService
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  ); // Redirect to Login page
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error logging out: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    const Color(0xFFD1A73E), // Set background color
                foregroundColor:
                    Colors.black, // Set text/icon color for contrast
              ),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                topGreetingBar("Githmi"), // Replace with dynamic user name

                const SizedBox(height: 30),

                // Profile Image
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.transparent,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/images/defaultpropic.png')
                            as ImageProvider,
                  ),
                ),

                const SizedBox(height: 40),

                // Golden Buttons
                buildGoldButton("Account Information", () {
                  Navigator.pushNamed(context, '/account_information');
                }),
                buildGoldButton("Address Book", () {
                  Navigator.pushNamed(context, '/address_book');
                }),
                buildGoldButton("Policies", () {}),
                buildGoldButton("Help", () {}),

                const SizedBox(height: 40),

                // Logout Button
                GestureDetector(
                  onTap: _showLogoutConfirmation, // Trigger logout confirmation
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFB63A3A),
                          Color(0xFFE57373),
                          Color(0xFFB63A3A),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Text(
                      "LOGOUT",
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                const Spacer(),

                // Bottom Navigation Bar
                //bottomNavBar(context, 4), // Index 4 = Profile
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4, // Index 4 for profile
        onTap: (index) {
          // Navigation handled by the BottomNavBar
        },
      ),
    );
  }

  Widget buildGoldButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(191, 155, 67, 1),
                Color.fromRGBO(217, 182, 106, 1),
                Color.fromRGBO(191, 155, 67, 1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  color: Colors.black, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
