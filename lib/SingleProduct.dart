import 'package:flutter/material.dart';
import 'components.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/product.jpg', // Add your image in assets
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: 16),

            // Title
            Text(
              'Cardamom Rose - Bath & Shower Gel 250ml',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 8),

            // Price and Payment Options
            Text('Rs 3,900', style: TextStyle(fontSize: 18)),
            Text('or 3 X Rs 1,300 with Mintpay / Koko',
                style: TextStyle(color: Colors.grey)),

            SizedBox(height: 8),

            // Ratings
            Row(
              children: [
                Row(
                  children: List.generate(
                      5,
                      (index) =>
                          Icon(Icons.star, color: Colors.amber, size: 20)),
                ),
                SizedBox(width: 5),
                Text('12 reviews')
              ],
            ),

            SizedBox(height: 16),

            // Quantity Selector
            Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text('$quantity', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 16),

            // Description
            Text(
              'A mild cleansing formula infused with precious herbs pure aromatic essential oils.',
              style: TextStyle(fontSize: 16),
            ),

            SizedBox(height: 24),

            // Buttons
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.black),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Add to cart'),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Buy it now'),
            ),
          ],
        ),
      ),
    );
  }
}
