import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';



class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      home: WellnessHomePage(),
    );
  }
}

class WellnessHomePage extends StatefulWidget {
  @override
  _WellnessHomePageState createState() => _WellnessHomePageState();
}

class _WellnessHomePageState extends State<WellnessHomePage> {
  final List<Map<String, String>> categories = [
    {'label': 'Baby Care', 'image': 'assets/images/baby_care.png'},
    {'label': 'Skin Wellness', 'image': 'assets/images/skin_care.png'},
    {'label': 'Mind & Body', 'image': 'assets/images/mind_body.png'},
    {'label': 'Hair Wellness', 'image': 'assets/images/hair_wellness.png'},
    {'label': 'Home Wellness', 'image': 'assets/images/home_wellness.png'},
    {'label': 'Fragrances', 'image': 'assets/images/fragrances.png'},
    {'label': 'Homeware', 'image': 'assets/images/homeware.png'},
    {'label': 'Gifting', 'image': 'assets/images/gifting.png'},
  ];

  final List<String> banners = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
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
                          .map((category) => Column(
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
    );
  }
}
