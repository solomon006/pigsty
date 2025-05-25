import 'package:flutter/material.dart';
import 'package:delicious/models/product.dart';
import 'package:delicious/services/product_service.dart';
import 'package:delicious/screens/product_detail_screen.dart';
import 'package:delicious/screens/cart_screen.dart';
import 'package:delicious/widgets/category_card.dart';
import 'package:delicious/widgets/product_card.dart';
import 'package:provider/provider.dart';
import 'package:delicious/providers/cart_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final List<Map<String, dynamic>> _categories = [
    {'id': 'all', 'name': 'All', 'icon': Icons.restaurant},
    {'id': 'burgers', 'name': 'Burgers', 'icon': Icons.lunch_dining},
    {'id': 'pizzas', 'name': 'Pizzas', 'icon': Icons.local_pizza},
    {'id': 'drinks', 'name': 'Drinks', 'icon': Icons.local_drink},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Shop'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (context.watch<CartProvider>().itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${context.watch<CartProvider>().itemCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for food',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Categories
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return CategoryCard(
                        icon: category['icon'],
                        title: category['name'],
                        isSelected: _selectedCategory == category['id'],
                        onTap: () {
                          setState(() {
                            _selectedCategory = category['id'];
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Products
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _selectedCategory == 'all'
                  ? _productService.getProducts()
                  : _productService.getProductsByCategory(_selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                  final products = snapshot.data ?? [];
                
                // Filter products based on search query
                final filteredProducts = products.where((product) {
                  final matchesSearch = _searchQuery.isEmpty || 
                      product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      product.description.toLowerCase().contains(_searchQuery.toLowerCase());
                  return matchesSearch;
                }).toList();
                
                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Text(_searchQuery.isEmpty ? 'No products available' : 'No products found for "$_searchQuery"'),
                  );
                }
                
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (ctx, i) => ProductCard(
                      product: filteredProducts[i],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(product: filteredProducts[i]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
