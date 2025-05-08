import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      home: HairCarePage(),
    );
  }
}

class HairCarePage extends StatefulWidget {
  const HairCarePage({super.key});

  @override
  _HairCarePageState createState() => _HairCarePageState();
}

class _HairCarePageState extends State<HairCarePage> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                topGreetingBar("Githmi"),

                // Category title and filter
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "HAIR WELLNESS",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Filter",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.filter_list,
                              size: 20, color: Colors.white),
                        ],
                      )
                    ],
                  ),
                ),

                // Product Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.65,
                      children: List.generate(5, (index) {
                        return productCard();
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        
      ),
    );
  }

  Widget productCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/hair_wellness.png', // <--- Make sure this image exists
                  width: 80,
                  height: 80,
                ),
              ),
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Argan Oil - Hair Strengthening Shampoo 200ml',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, size: 14),
                    Icon(Icons.star, size: 14),
                    Icon(Icons.star, size: 14),
                    Icon(Icons.star_half, size: 14),
                    Icon(Icons.star_border, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '(120 Reviews)',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Rs. 3,950',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Center(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Add To Cart",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
