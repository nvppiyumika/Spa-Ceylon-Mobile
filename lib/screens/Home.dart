import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:spa_ceylon_mobile/screens/Products.dart'; // Import the Products page

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const WellnessHomePage();
  }
}

class WellnessHomePage extends StatefulWidget {
  const WellnessHomePage({super.key});

  @override
  _WellnessHomePageState createState() => _WellnessHomePageState();
}

class _WellnessHomePageState extends State<WellnessHomePage> {
  final List<Map<String, String>> categories = [
    {
      'label': 'Baby Care',
      'image': 'assets/images/baby_care.png',
      'id': 'baby_care'
    },
    {
      'label': 'Skin Wellness',
      'image': 'assets/images/skin_care.png',
      'id': 'skin_wellness'
    },
    {
      'label': 'Mind & Body',
      'image': 'assets/images/mind_body.png',
      'id': 'mind_body'
    },
    {
      'label': 'Hair Wellness',
      'image': 'assets/images/hair_wellness.png',
      'id': 'hair_wellness'
    },
    {
      'label': 'Home Wellness',
      'image': 'assets/images/home_wellness.png',
      'id': 'home_wellness'
    },
    {
      'label': 'Fragrances',
      'image': 'assets/images/fragrances.png',
      'id': 'fragrances'
    },
    {
      'label': 'Homeware',
      'image': 'assets/images/homeware.png',
      'id': 'homeware'
    },
    {'label': 'Gifting', 'image': 'assets/images/gifting.png', 'id': 'gifting'},
  ];

  final List<String> banners = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final cartStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('cart')
        .snapshots();
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: cartStream,
      builder: (context, snapshot) {
        int cartItemCount = 0;
        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data();
            cartItemCount += (data['quantity'] ?? 1) as int;
          }
        }
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground UI
          SafeArea(
            child: Column(
              children: [
                topGreetingBar("Githmi"),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 18),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Here',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                ),

                // Carousel Slider
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: Duration(seconds: 5),
                    viewportFraction: 0.9,
                  ),
                  items: banners.map((banner) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        banner,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  }).toList(),
                ),

                // Categories Title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'EXPLORE OUR WELLNESS CATEGORIES',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Categories Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 30,
                      children: categories
                          .map((category) => GestureDetector(
                                onTap: () {
                                  // Navigate to the Products page with category details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Products(
                                        categoryId: category['id']!,
                                        categoryName: category['label']!,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        category['image']!,
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      category['label']!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        cartItemCount: cartItemCount, // Set the current index for the Home tab
      ),
    );
        }
      );
  }
}
