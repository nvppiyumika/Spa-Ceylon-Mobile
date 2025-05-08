import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart'; // Import your custom top greeting bar

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  //int _selectedIndex = 2;

  final List<Map<String, String>> promotions = const [
    {
      'title': '50% OFF on Wellness Products',
      'description':
          'Get amazing discounts on selected wellness products. Limited time offer!',
      'validity': 'Valid until: 30th April'
    },
    {
      'title': 'Free Consultation',
      'description':
          'Book a free consultation with our wellness experts today!',
      'validity': 'Valid until: 25th April'
    },
    {
      'title': 'Buy 1 Get 1 Free',
      'description': 'Buy one wellness service and get another one for free.',
      'validity': 'Valid until: 28th April'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg', // Background image
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                topGreetingBar("Githmi"), // Custom top greeting bar
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: promotions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final promotion = promotions[index];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
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
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your action here for "See Offers" button
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(191, 155, 67, 1),
                              Color.fromRGBO(217, 182, 106, 1),
                              Color.fromRGBO(191, 155, 67, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      //bottomNavigationBar: bottomNavBar(context, _selectedIndex, _onNavTapped), // Add bottom nav bar if needed
    );
  }
}
