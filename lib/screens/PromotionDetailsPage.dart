import 'package:flutter/material.dart';

class PromotionDetailsPage extends StatelessWidget {
  final String title;
  final String description;
  final String validity;

  const PromotionDetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.validity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text(validity, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}