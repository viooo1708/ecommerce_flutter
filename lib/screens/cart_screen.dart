import 'package:flutter/material.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  double _calculateTotal(List<CartItem> items) {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Fungsi untuk menampilkan detail cart item
  void _showCartItemDetail(BuildContext context, CartItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFDE8F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantity: ${item.quantity}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Price per unit: \$${item.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Total: \$${(item.price * item.quantity).toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();

    return Scaffold(
      backgroundColor: const Color(0xFFFDE8F0),
      appBar: AppBar(
        title: const Text('Shopping Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8BBD0),
        elevation: 2,
      ),
      body: FutureBuilder<List<CartItem>>(
        future: cartService.getCarts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Failed to load cart\n${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.remove_shopping_cart_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Your cart is empty', style: TextStyle(fontSize: 20, color: Colors.grey)),
                ],
              ),
            );
          }

          final items = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GestureDetector(
                      onTap: () => _showCartItemDetail(context, item), // detail popup
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8BBD0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                          ),
                          title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${item.quantity} x \$${item.price.toStringAsFixed(2)}'),
                          trailing: Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        Text('\$${_calculateTotal(items).toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF48FB1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Checkout is not implemented.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
