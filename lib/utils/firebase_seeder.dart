import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseDataSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Seed initial products
  Future<void> seedProducts() async {
    try {
      final productsCollection = _firestore.collection('products');
      
      // Check if products already exist
      final snapshot = await productsCollection.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        debugPrint('Products already seeded, skipping...');
        return;
      }
      
      // Burgers
      await _addProduct(productsCollection, {
        'name': 'Classic Cheeseburger',
        'description': 'Juicy beef patty with melted cheddar cheese, lettuce, tomato, and special sauce',
        'price': 8.99,
        'imageUrl': 'https://picsum.photos/400/300?random=1',
        'category': 'burgers',
      });

      await _addProduct(productsCollection, {
        'name': 'Bacon Burger',
        'description': 'Beef patty with crispy bacon, cheese, lettuce, and BBQ sauce',
        'price': 10.99,
        'imageUrl': 'https://picsum.photos/400/300?random=2',
        'category': 'burgers',
      });

      await _addProduct(productsCollection, {
        'name': 'Veggie Burger',
        'description': 'Plant-based patty with avocado, lettuce, tomato, and vegan mayo',
        'price': 9.99,
        'imageUrl': 'https://picsum.photos/400/300?random=3',
        'category': 'burgers',
      });

      // Pizzas
      await _addProduct(productsCollection, {
        'name': 'Margherita Pizza',
        'description': 'Fresh tomato sauce, mozzarella, and basil',
        'price': 12.99,
        'imageUrl': 'https://picsum.photos/400/300?random=4',
        'category': 'pizzas',
      });

      await _addProduct(productsCollection, {
        'name': 'Pepperoni Pizza',
        'description': 'Tomato sauce, mozzarella, and pepperoni slices',
        'price': 14.99,
        'imageUrl': 'https://picsum.photos/400/300?random=5',
        'category': 'pizzas',
      });

      await _addProduct(productsCollection, {
        'name': 'Vegetarian Pizza',
        'description': 'Tomato sauce, mozzarella, bell peppers, mushrooms, and olives',
        'price': 13.99,
        'imageUrl': 'https://picsum.photos/400/300?random=6',
        'category': 'pizzas',
      });

      // Drinks
      await _addProduct(productsCollection, {
        'name': 'Iced Coffee',
        'description': 'Cold brewed coffee with a hint of vanilla',
        'price': 3.99,
        'imageUrl': 'https://picsum.photos/400/300?random=7',
        'category': 'drinks',
      });

      await _addProduct(productsCollection, {
        'name': 'Fruit Smoothie',
        'description': 'Blend of fresh fruits and yogurt',
        'price': 4.99,
        'imageUrl': 'https://picsum.photos/400/300?random=8',
        'category': 'drinks',
      });

      await _addProduct(productsCollection, {
        'name': 'Sparkling Water',
        'description': 'Refreshing sparkling water with lime',
        'price': 2.49,
        'imageUrl': 'https://picsum.photos/400/300?random=9',
        'category': 'drinks',
      });

      debugPrint('Products seeded successfully!');
    } catch (error) {
      debugPrint('Error seeding products: $error');
    }
  }

  Future<void> _addProduct(CollectionReference collection, Map<String, dynamic> data) async {
    await collection.add(data);
  }
}
