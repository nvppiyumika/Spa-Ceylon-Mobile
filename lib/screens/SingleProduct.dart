import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wellness App',
      debugShowCheckedModeBanner: false,
      home: SingleProductPage(),
    );
  }
}

class SingleProductPage extends StatefulWidget {
  @override
  _SingleProductPageState createState() => _SingleProductPageState();
}

class _SingleProductPageState extends State<SingleProductPage> {
  int _selectedIndex = 0;
  int _quantity = 1; // Starting quantity

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
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
                        "SKIN WELLNESS",
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Center(
                        child: productCard(),
                      ),
                    ),
                  ),
                ),
                BottomNavBar(
                  currentIndex: 0, // Set the initial selected index
                  onTap: (index) {
                    // Navigation handled by the BottomNavBar
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productCard() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Product Image (Square, Large)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/skin_care.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          SizedBox(height: 8),

          // Row 2: Product Description
          Text(
            'Frankincense - Face Wash For Men 150ml',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.star, size: 14),
              Icon(Icons.star, size: 14),
              Icon(Icons.star, size: 14),
              Icon(Icons.star_half, size: 14),
              Icon(Icons.star_border, size: 14),
              SizedBox(width: 6),
              Text(
                '(67 Reviews)',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'Rs. 4,550',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green[700]),
          ),
          SizedBox(height: 16),

          // Row 3: Quantity Adjustment with border around -1+
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Quantity: ",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _decreaseQuantity,
                      icon: Icon(Icons.remove),
                      color: Colors.black,
                    ),
                    Text(
                      '$_quantity',
                      style: TextStyle(fontSize: 14),
                    ),
                    IconButton(
                      onPressed: _increaseQuantity,
                      icon: Icon(Icons.add),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 8),
          Text(
            "A deep-cleansing formula with powerful Ayurveda WonderHerbs to lift-off dust, pollution, impurities & excess surface oil, to minimize skin shine.",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),

          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //
              OutlinedButton(
                onPressed: () {},
                child: Text("Add to Cart"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.black),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(191, 155, 67, 1),
                      Color.fromRGBO(217, 182, 106, 1),
                      Color.fromRGBO(191, 155, 67, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text("Buy Now"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
