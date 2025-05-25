import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious/models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'products';

  // Get all products
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection(collection)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
        });
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection(collection)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
        });
  }

  // Get a single product by id
  Future<Product?> getProductById(String id) async {
    final doc = await _firestore.collection(collection).doc(id).get();
    
    if (doc.exists) {
      return Product.fromFirestore(doc);
    }
    return null;
  }

  // Add a product (for admin purposes)
  Future<String> addProduct(Product product) async {
    final docRef = await _firestore.collection(collection).add(product.toMap());
    return docRef.id;
  }

  // Update a product (for admin purposes)
  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(id).update(data);
  }

  // Delete a product (for admin purposes)
  Future<void> deleteProduct(String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }
  // Search products by name
  Future<List<Product>> searchProducts(String query) async {
    // Perform a simple search by name containing the query
    // For more advanced search, consider using Algolia or ElasticSearch
    final snapshot = await _firestore
        .collection(collection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
        
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }
}
