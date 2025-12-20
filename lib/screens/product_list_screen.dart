// import 'package:flutter/material.dart';
// import '../models/product.dart';
// import '../services/api_service.dart';
// import 'product_detail_screen.dart';
// import 'all_reviews_screen.dart';
// import 'cart_screen.dart';
// import 'user_list_screen.dart';
//
// // Tambahkan halaman UserScreen
// class UserScreen extends StatelessWidget {
//   const UserScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.person, size: 80, color: Colors.pinkAccent),
//           SizedBox(height: 16),
//           Text(
//             'User Profile',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ProductListScreen extends StatefulWidget {
//   const ProductListScreen({Key? key}) : super(key: key);
//
//   @override
//   _ProductListScreenState createState() => _ProductListScreenState();
// }
//
// class _ProductListScreenState extends State<ProductListScreen> {
//   late Future<List<Product>> futureProducts;
//   final ApiService apiService = ApiService();
//   int _currentIndex = 0; // Bottom navbar index
//
//   @override
//   void initState() {
//     super.initState();
//     futureProducts = apiService.getProducts();
//   }
//
//   // Halaman masing-masing tab
//   List<Widget> get _pages => [
//     _buildProductTab(),
//     const AllReviewsScreen(),
//     const UserListScreen(), // sekarang User terpisah dari Cart
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.pink[50],
//       appBar: AppBar(
//         title: const Text(
//           'E-Commerce',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.pink[300],
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart_outlined, size: 28),
//             onPressed: () {
//               // Navigasi ke CartScreen secara terpisah
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const CartScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _pages,
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.pink[400],
//         unselectedItemColor: Colors.grey[500],
//         showUnselectedLabels: true,
//         selectedFontSize: 14,
//         unselectedFontSize: 13,
//         onTap: (index) => setState(() => _currentIndex = index),
//         backgroundColor: Colors.white,
//         elevation: 6,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_bag, size: 26),
//             label: 'Product',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.reviews, size: 26),
//             label: 'Review',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person, size: 26),
//             label: 'User',
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Tab Product
//   Widget _buildProductTab() {
//     return FutureBuilder<List<Product>>(
//       future: futureProducts,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No products found'));
//         } else {
//           return GridView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//             itemCount: snapshot.data!.length,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 0.75,
//             ),
//             itemBuilder: (context, index) {
//               final product = snapshot.data![index];
//               return Material(
//                 color: Colors.pink[100],
//                 borderRadius: BorderRadius.circular(16),
//                 elevation: 4,
//                 shadowColor: Colors.grey.withOpacity(0.2),
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(16),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             ProductDetailScreen(productId: product.id),
//                       ),
//                     );
//                   },
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.pink[50],
//                             borderRadius: const BorderRadius.vertical(
//                                 top: Radius.circular(16)),
//                           ),
//                           child: const Center(
//                             child: Icon(
//                               Icons.shopping_bag,
//                               size: 50,
//                               color: Colors.pinkAccent,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               product.name,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               '\$${product.price.toStringAsFixed(2)}',
//                               style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.pinkAccent),
//                             ),
//                             const SizedBox(height: 8),
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.pink[300],
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 10),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => ProductDetailScreen(
//                                           productId: product.id),
//                                     ),
//                                   );
//                                 },
//                                 child: const Text('Lihat Detail'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';
import 'add_edit_product_screen.dart';
import 'package:intl/intl.dart'; // <-- untuk format harga

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;
  final ApiService _apiService = ApiService();
  final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = _apiService.getProducts();
    });
  }

  Future<void> _openDetail(Product product) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );

    if (result == true) {
      _loadProducts();
    }
  }

  Future<void> _addProduct() async {
    final result = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditProductScreen(),
      ),
    );

    if (result != null) {
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tema pink pastel
    final Color pastelPinkLight = const Color(0xFFFCE4EC); // background card
    final Color pastelPinkDark = const Color(0xFFF48FB1);  // AppBar / accent
    final Color pastelPinkText = const Color(0xFFC2185B);  // teks & icon

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: pastelPinkDark,
      ),
      body: RefreshIndicator(
        color: pastelPinkDark,
        onRefresh: () async => _loadProducts(),
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final products = snapshot.data;

            if (products == null || products.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: pastelPinkLight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _openDetail(product),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: pastelPinkDark,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: pastelPinkText,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currencyFormatter.format(product.price),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: pastelPinkText.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: pastelPinkText.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: pastelPinkText.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addProduct,
        backgroundColor: pastelPinkDark,
        child: const Icon(Icons.add),
      ),
    );
  }
}
