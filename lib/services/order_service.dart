import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious/models/order.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection = 'orders';
  final uuid = const Uuid();

  // Create a new order
  Future<String> createOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required String? address,
    required String? phoneNumber,
  }) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      final orderId = uuid.v4();
      final order = model.Order(
        id: orderId,
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        createdAt: DateTime.now(),
        status: model.OrderStatus.pending,
        address: address,
        phoneNumber: phoneNumber,
      );

      await _firestore.collection(collection).doc(orderId).set(order.toMap());
      return orderId;
    } catch (e) {
      rethrow;
    }
  }
  // Get all orders for current user
  Stream<List<model.Order>> getUserOrders() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs.map((doc) => model.Order.fromFirestore(doc)).toList();
          // Сортируем на стороне клиента
          orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return orders;
        });
  }

  // Get a single order by id
  Future<model.Order?> getOrderById(String id) async {
    final doc = await _firestore.collection(collection).doc(id).get();
    
    if (doc.exists) {
      return model.Order.fromFirestore(doc);
    }
    return null;
  }

  // Update order status (for admin purposes)
  Future<void> updateOrderStatus(String orderId, model.OrderStatus status) async {
    await _firestore
        .collection(collection)
        .doc(orderId)
        .update({'status': status.toString().split('.').last});
  }

  // Cancel an order
  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, model.OrderStatus.cancelled);
  }
}