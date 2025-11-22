import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';
import 'all_reviews_screen.dart';
import 'cart_screen.dart';
import 'user_list_screen.dart';

// Tambahkan halaman UserScreen
class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.person, size: 80, color: Colors.pinkAccent),
          SizedBox(height: 16),
          Text(
            'User Profile',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;
  final ApiService apiService = ApiService();
  int _currentIndex = 0; // Bottom navbar index

  @override
  void initState() {
    super.initState();
    futureProducts = apiService.getProducts();
  }

  // Halaman masing-masing tab
  List<Widget> get _pages => [
    _buildProductTab(),
    const AllReviewsScreen(),
    const UserListScreen(), // sekarang User terpisah dari Cart
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text(
          'E-Commerce',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, size: 28),
            onPressed: () {
              // Navigasi ke CartScreen secara terpisah
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pink[400],
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        selectedFontSize: 14,
        unselectedFontSize: 13,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        elevation: 6,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag, size: 26),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews, size: 26),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 26),
            label: 'User',
          ),
        ],
      ),
    );
  }

  // Tab Product
  Widget _buildProductTab() {
    return FutureBuilder<List<Product>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        } else {
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: snapshot.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return Material(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(16),
                elevation: 4,
                shadowColor: Colors.grey.withOpacity(0.2),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(productId: product.id),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.shopping_bag,
                              size: 50,
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pinkAccent),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink[300],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetailScreen(
                                          productId: product.id),
                                    ),
                                  );
                                },
                                child: const Text('Lihat Detail'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
