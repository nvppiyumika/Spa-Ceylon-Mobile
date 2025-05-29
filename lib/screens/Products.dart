import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart';
import 'package:spa_ceylon_mobile/models/productModel.dart';
import 'package:spa_ceylon_mobile/services/productService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Products extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const Products(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return ProductsPage(categoryId: categoryId, categoryName: categoryName);
  }
}

class ProductsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const ProductsPage(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductService _productService = ProductService();
  String _sortOption =
      'default'; // 'default', 'priceLowToHigh', 'priceHighToLow', 'ratingLowToHigh', 'ratingHighToLow'
  String _sortBy = 'price'; // Default sort field
  bool _descending = false; // Default sort direction

  void _updateSortOption(String option) {
    setState(() {
      _sortOption = option;
      switch (option) {
        case 'priceLowToHigh':
          _sortBy = 'price';
          _descending = false;
          break;
        case 'priceHighToLow':
          _sortBy = 'price';
          _descending = true;
          break;
        case 'ratingLowToHigh':
          _sortBy = 'rating';
          _descending = false;
          break;
        case 'ratingHighToLow':
          _sortBy = 'rating';
          _descending = true;
          break;
        default:
          _sortBy = 'price';
          _descending = false;
      }
    });
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              _buildFilterOption(context, 'default', 'Default'),
              _buildFilterOption(
                  context, 'priceLowToHigh', 'Price: Low to High'),
              _buildFilterOption(
                  context, 'priceHighToLow', 'Price: High to Low'),
              _buildFilterOption(
                  context, 'ratingLowToHigh', 'Rating: Low to High'),
              _buildFilterOption(
                  context, 'ratingHighToLow', 'Rating: High to Low'),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(BuildContext context, String value, String label) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: _sortOption == value ? Colors.black : Colors.grey,
          fontWeight:
              _sortOption == value ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing:
          _sortOption == value ? Icon(Icons.check, color: Colors.black) : null,
      onTap: () {
        _updateSortOption(value);
        Navigator.pop(context);
      },
    );
  }

  Future<void> addToCart({
    required String name,
    required double price,
    required String imageUrl,
    required double rating,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log in to add items to cart.")),
      );
      return;
    }
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart');

    // Check if product already in cart
    final existing = await cartRef.where('name', isEqualTo: name).limit(1).get();
    if (existing.docs.isNotEmpty) {
      // If exists, increment quantity
      final doc = existing.docs.first;
      await cartRef.doc(doc.id).update({
        'quantity': (doc['quantity'] ?? 1) + 1,
      });
    } else {
      // If not, add new item
      await cartRef.add({
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
        'rating': rating,
        'quantity': 1,
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Added to cart!")),
    );
  }

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
                            widget.categoryName.toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showFilterOptions(context),
                            icon: Icon(Icons.filter_list,
                                size: 20, color: Colors.black),
                            label: Text(
                              'Filter',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding:
                                  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Product Grid
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: StreamBuilder<List<ProductModel>>(
                          stream: _productService.getProductsByCategory(
                            widget.categoryId,
                            sortBy: _sortBy,
                            descending: _descending,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text(
                                      'Error loading products: ${snapshot.error}'));
                            }
                            final products = snapshot.data ?? [];
                            if (products.isEmpty) {
                              return Center(
                                  child: Text(
                                      'No products found for category: ${widget.categoryId}'));
                            }

                            return GridView.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.65,
                              children: List.generate(products.length, (index) {
                                final product = products[index];
                                return productCard(
                                  name: product.name,
                                  price: product.price,
                                  imageUrl: product.imageUrl,
                                  rating: product.rating,
                                );
                              }),
                            );
                          },
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0, // Set the current index for the Home tab
            cartItemCount: cartItemCount, // Always show cart count
          ),
        );
      },
    );
  }

  Widget productCard({
    required String name,
    required double price,
    required String imageUrl,
    required double rating,
  }) {
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
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Text('Image not found'));
                  },
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
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 4),
                Row(
                  children: _buildRatingStars(rating),
                ),
                SizedBox(height: 4),
                Text(
                  'Rs. ${price.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      addToCart(
                        name: name,
                        price: price,
                        imageUrl: imageUrl,
                        rating: rating,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
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

  List<Widget> _buildRatingStars(double rating) {
    List<Widget> stars = [];
    const double maxRating = 5.0;
    const double starSize = 14.0;

    // Ensure rating is within valid range (0 to 5)
    rating = rating.clamp(0.0, maxRating);

    // Calculate full stars
    int fullStars = rating.floor();
    // Calculate if there's a half star
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, size: starSize, color: Colors.black));
    }

    // Add half star if applicable
    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, size: starSize, color: Colors.black));
    }

    // Add empty stars to make total 5
    int remainingStars = maxRating.ceil() - fullStars - (hasHalfStar ? 1 : 0);
    for (int i = 0; i < remainingStars; i++) {
      stars.add(Icon(Icons.star_border, size: starSize, color: Colors.black));
    }

    // Add the rating value after the stars
    stars.add(SizedBox(width: 4));
    stars.add(
      Text(
        rating.toStringAsFixed(1),
        style: TextStyle(fontSize: 12, color: Colors.black),
      ),
    );

    return stars;
  }
}
