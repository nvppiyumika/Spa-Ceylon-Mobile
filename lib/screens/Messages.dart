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

    // Stream for user messages
    final messagesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: cartStream,
      builder: (context, cartSnapshot) {
        int cartItemCount = 0;
        if (cartSnapshot.hasData) {
          for (var doc in cartSnapshot.data!.docs) {
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
                        stream: messagesStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No messages yet.'));
                          }
                          final messages = snapshot.data!.docs;
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: messages.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final message = messages[index].data();
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
                          onPressed: () async {
                            // Clear all messages in the user's messages subcollection
                            final user = FirebaseAuth.instance.currentUser;
                            final messagesRef = FirebaseFirestore.instance
                                .collection('users')
                                .doc(user?.uid)
                                .collection('messages');

                            final batch = FirebaseFirestore.instance.batch();
                            final messagesSnapshot = await messagesRef.get();
                            for (var doc in messagesSnapshot.docs) {
                              batch.delete(doc.reference);
                            }
                            await batch.commit();
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
