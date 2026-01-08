import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFF48FB1);
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Detail Product'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor: Colors.grey.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Price: \$${product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.shopping_cart),
                      label: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await cartProvider.addToCart(CartItem(
                          id: product.id!,
                          name: product.name,
                          price: product.price,
                          quantity: 1,
                        ));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Product added to cart')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
