import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spa_ceylon_mobile/models/productModel.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class ProductService {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  Stream<List<ProductModel>> getProductsByCategory(
    String category, {
    bool descending = false,
    required String sortBy,
  }) {
    debugPrint(
        'Fetching products for category: $category, sortBy: $sortBy, descending: $descending');

    Query query = _productsCollection.where('category', isEqualTo: category);

    // Apply sorting based on sortBy parameter
    if (sortBy != 'default') {
      query = query.orderBy(sortBy, descending: descending);
    }

    return query.snapshots().map((snapshot) {
      debugPrint(
          'Found ${snapshot.docs.length} products for category: $category');
      return snapshot.docs
          .map((doc) => ProductModel.fromDocument(doc))
          .toList();
    }).handleError((error) {
      debugPrint('Error fetching products: $error');
      return [];
    });
  }
}
