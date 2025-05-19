import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  // Get current user's cart collection
  CollectionReference<Map<String, dynamic>> getCartCollection() {
    final user = FirebaseAuth.instance.currentUser;
    // If you want a global cart, use FirebaseFirestore.instance.collection('cart');
    // For per-user cart:
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('cart');
  }

  Future<void> updateQuantity(String docId, int newQuantity) async {
    if (newQuantity < 1) return;
    await getCartCollection().doc(docId).update({'quantity': newQuantity});
  }

  Future<void> deleteItem(String docId) async {
    await getCartCollection().doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                topGreetingBar("User"), // Replace with actual user name
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: getCartCollection().snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "Your cart is empty.",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        );
                      }
                      final cartDocs = snapshot.data!.docs;
                      double total = 0;
                      for (var doc in cartDocs) {
                        final data = doc.data();
                        total += (data['price'] ?? 0) * (data['quantity'] ?? 1);
                      }
                      return ListView.separated(
                        itemCount: cartDocs.length,
                        padding: const EdgeInsets.all(16),
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white24),
                        itemBuilder: (context, index) {
                          final doc = cartDocs[index];
                          final data = doc.data();
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.spa, color: Colors.black),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'] ?? '',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${(data['price'] ?? 0).toStringAsFixed(2)}',
                                      style: const TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.white),
                                    onPressed: (data['quantity'] ?? 1) > 1
                                        ? () => updateQuantity(doc.id, data['quantity'] - 1)
                                        : null,
                                  ),
                                  Text(
                                    (data['quantity'] ?? 1).toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle, color: Colors.white),
                                    onPressed: () => updateQuantity(doc.id, data['quantity'] + 1),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () => deleteItem(doc.id),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                // 💰 Total + Gradient Proceed Button
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: getCartCollection().snapshots(),
                  builder: (context, snapshot) {
                    double total = 0;
                    if (snapshot.hasData) {
                      for (var doc in snapshot.data!.docs) {
                        final data = doc.data();
                        total += (data['price'] ?? 0) * (data['quantity'] ?? 1);
                      }
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: const BoxDecoration(
                        color: Colors.black87,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total",
                                  style: TextStyle(color: Colors.white, fontSize: 18)),
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color.fromRGBO(191, 155, 67, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              // Add checkout functionality here
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromRGBO(191, 155, 67, 1),
                                    Color.fromRGBO(217, 182, 106, 1),
                                    Color.fromRGBO(191, 155, 67, 1)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'PROCEED TO CHECKOUT',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {},
      ),
    );
  }
}
