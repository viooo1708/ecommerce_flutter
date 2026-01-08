import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: const Color(0xFFF48FB1),
      ),
      body: cartProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : cartProvider.items.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: cartProvider.items.length,
              itemBuilder: (_, i) {
                final item = cartProvider.items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    title: Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Quantity: ${item.quantity}  •  Price: \$${item.price.toStringAsFixed(2)}'),
                    trailing: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: const Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${cartProvider.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48FB1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Checkout'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Checkout pressed')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
