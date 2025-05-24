import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spa_ceylon_mobile/widgets/BottomNavBar.dart';
import 'package:spa_ceylon_mobile/widgets/top_greeting_bar.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  int _currentIndex = 1;
  final List<Map<String, String>> messages = const [
    {
      'sender': 'Wellness Bot',
      'message': 'Welcome to our app!',
      'time': '2 mins ago'
    },
    {
      'sender': 'Admin',
      'message': 'Don’t forget your daily check-in.',
      'time': '1 hour ago'
    },
    {
      'sender': 'Support',
      'message': 'Your request has been received.',
      'time': 'Yesterday'
    },
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
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
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: messages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                message['sender'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(message['message'] ?? ''),
                              trailing: Text(
                                message['time'] ?? '',
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
                            // Add your clear inbox logic here
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
                              child: const Text(
                                'Clear Inbox',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
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
          bottomNavigationBar: BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            cartItemCount: cartItemCount, // Always show cart count
          ),
        );
      },
    );
  }
}
