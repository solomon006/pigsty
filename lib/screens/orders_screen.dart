import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delicious/models/order.dart' as model;
import 'package:delicious/providers/auth_provider.dart';
import 'package:delicious/screens/login_screen.dart';
import 'package:delicious/screens/order_detail_screen.dart';
import 'package:delicious/services/order_service.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isAuthenticated = authProvider.isAuthenticated;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: !isAuthenticated
          ? _buildNotAuthenticatedView(context)
          : _buildOrdersList(),
    );
  }
  
  Widget _buildNotAuthenticatedView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Please login to view your orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Login to access your order history',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('LOGIN'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrdersList() {
    final orderService = OrderService();
    
    return StreamBuilder<List<model.Order>>(
      stream: orderService.getUserOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        
        final orders = snapshot.data ?? [];
        
        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No orders found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your order history will appear here',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (ctx, i) => Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OrderDetailScreen(order: orders[i]),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${orders[i].id.substring(0, 8)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        _buildStatusBadge(orders[i].status),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Date: ${DateFormat('MMM dd, yyyy - hh:mm a').format(orders[i].createdAt)}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Items: ${orders[i].items.length}',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${orders[i].totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildStatusBadge(model.OrderStatus status) {
    late Color color;
    late String text;
    
    switch (status) {
      case model.OrderStatus.pending:
        color = Colors.blue;
        text = 'Pending';
        break;
      case model.OrderStatus.processing:
        color = Colors.orange;
        text = 'Processing';
        break;
      case model.OrderStatus.shipped:
        color = Colors.indigo;
        text = 'Shipped';
        break;
      case model.OrderStatus.delivered:
        color = Colors.green;
        text = 'Delivered';
        break;
      case model.OrderStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 26),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
