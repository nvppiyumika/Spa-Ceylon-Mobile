import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class ProductModel {
  final String id;
  final String name;
  final double price;
  final String category;
  final String imageUrl;
  final double rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }

  factory ProductModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      debugPrint(
          'Error: Firestore document data is null for doc ID: ${doc.id}');
      return ProductModel(
        id: doc.id,
        name: '',
        price: 0.0,
        category: '',
        imageUrl: '',
        rating: 0.0,
      );
    }

    debugPrint('Parsing document: ${doc.id} with data: $data');
    return ProductModel(
      id: doc.id,
      name: data['name']?.toString() ?? '',
      price: (data['price'] is num)
          ? data['price'].toDouble()
          : double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0,
      category: data['category']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      rating: (data['rating'] is num)
          ? data['rating'].toDouble()
          : double.tryParse(data['rating']?.toString() ?? '0.0') ?? 0.0,
    );
  }
}
