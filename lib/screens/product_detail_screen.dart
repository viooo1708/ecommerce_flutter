// import 'package:flutter/material.dart';
// import '../models/product.dart';
// import '../services/api_service.dart';
//
// class ProductDetailScreen extends StatefulWidget {
//   final int productId;
//
//   const ProductDetailScreen({Key? key, required this.productId})
//       : super(key: key);
//
//   @override
//   _ProductDetailScreenState createState() => _ProductDetailScreenState();
// }
//
// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   late Future<Product> futureProduct;
//   final ApiService apiService = ApiService();
//
//   @override
//   void initState() {
//     super.initState();
//     futureProduct = apiService.getProductById(widget.productId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Product Detail'),
//         backgroundColor: const Color(0xFFF8BBD0), // Pink pastel
//       ),
//       body: FutureBuilder<Product>(
//         future: futureProduct,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text('Product not found'));
//           }
//
//           Product product = snapshot.data!;
//           return Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // IMAGE / ICON AREA
//                       Container(
//                         height: 300,
//                         width: double.infinity,
//                         color: const Color(0xFFFDE8F0), // Pink pastel lembut
//                         child: Center(
//                           child: Icon(
//                             Icons.shopping_bag_outlined,
//                             size: 100,
//                             color: const Color(0xFFF48FB1), // Pink pastel gelap
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               product.name,
//                               style: const TextStyle(
//                                   fontSize: 24, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 12),
//                             Text(
//                               '\$${product.price.toStringAsFixed(2)}',
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFFF48FB1), // Pink pastel
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                             Text(
//                               'Description',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.grey[800],
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               product.description,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 height: 1.5,
//                               ),
//                             ),
//                             const SizedBox(height: 80), // Space for button
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // ADD TO CART BUTTON
//               Container(
//                 padding: const EdgeInsets.all(24.0),
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).scaffoldBackgroundColor,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 10,
//                       offset: const Offset(0, -5),
//                     ),
//                   ],
//                 ),
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFF48FB1), // Pink pastel
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: () async {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('${product.name} added to cart'),
//                           backgroundColor: const Color(0xFFF48FB1), // Pink pastel
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'Add to Cart',
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'add_edit_product_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product product;
  final ApiService _apiService = ApiService();
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    // Tema pastel pink
    final Color pastelPinkLight = const Color(0xFFFCE4EC);
    final Color pastelPinkDark = const Color(0xFFF48FB1);
    final Color pastelPinkText = const Color(0xFFC2185B);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: pastelPinkDark,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: _editProduct,
          ),
          IconButton(
            icon: _isDeleting
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Icon(Icons.delete, color: Colors.white),
            onPressed: _isDeleting ? null : _deleteProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: pastelPinkLight,
          elevation: 6,
          shadowColor: pastelPinkDark.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoTile('Name', product.name, pastelPinkText, icon: Icons.label),
                const Divider(color: Colors.white54),
                _infoTile('Price', '\$${product.price}', pastelPinkText, icon: Icons.attach_money),
                const Divider(color: Colors.white54),
                _infoTile('Description', product.description, pastelPinkText, icon: Icons.description),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _editProduct() async {
    final updatedProduct = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditProductScreen(product: product),
      ),
    );

    if (updatedProduct != null) {
      setState(() {
        product = updatedProduct;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product updated')),
      );
    }
  }

  Future<void> _deleteProduct() async {
    if (product.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid product ID')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);

    try {
      await _apiService.deleteProduct(product.id!);

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() => _isDeleting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete product')),
      );
    }
  }

  Widget _infoTile(String label, String value, Color textColor, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 2),
              child: Icon(icon, size: 20, color: textColor.withOpacity(0.8)),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: textColor.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: textColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
