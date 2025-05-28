import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spa_ceylon_mobile/screens/PromotionDetailsPage.dart'; // Create this page

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final cartStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('cart')
        .snapshots();

    // Stream for promotions
    final promotionsStream = FirebaseFirestore.instance
        .collection('promotions')
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
          backgroundColor: Colors.black,
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
                    topGreetingBar("Githmi"),
                    const SizedBox(height: 8),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: promotionsStream,
                        builder: (context, promoSnapshot) {
                          if (promoSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!promoSnapshot.hasData || promoSnapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No promotions available.'));
                          }
                          final promotions = promoSnapshot.data!.docs;
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: promotions.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final promotion = promotions[index].data();
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        promotion['title'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(promotion['description'] ?? ''),
                                      trailing: Text(
                                        promotion['validity'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => PromotionDetailsPage(
                                                title: promotion['title'] ?? '',
                                                description: promotion['description'] ?? '',
                                                validity: promotion['validity'] ?? '',
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Try'),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: 2,
            onTap: (index) {},
            cartItemCount: cartItemCount,
          ),
        );
      },
    );
  }
}
