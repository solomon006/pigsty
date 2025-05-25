import 'package:delicious/models/product.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  // Internal state
  final List<CartItem> _items = [];
  
  // Getters
  List<CartItem> get items => _items;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount => _items.fold(
      0, (sum, item) => sum + (item.product.price * item.quantity));

  // Check if cart contains a product
  bool containsProduct(String productId) {
    return _items.any((item) => item.product.id == productId);
  }
  
  // Add item to cart
  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id
    );
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }
  
  // Remove item from cart
  void removeItem(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }
  
  // Decrease quantity
  void decreaseQuantity(String productId) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == productId
    );
    
    if (existingIndex >= 0) {
      if (_items[existingIndex].quantity > 1) {
        _items[existingIndex].quantity--;
      } else {
        _items.removeAt(existingIndex);
      }
      notifyListeners();
    }
  }
  
  // Increase quantity
  void increaseQuantity(String productId) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == productId
    );
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
      notifyListeners();
    }
  }
  
  // Clear cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Convert cart items to order items format
  List<Map<String, dynamic>> toOrderItems() {
    return _items.map((item) => item.toMap()).toList();
  }
}
