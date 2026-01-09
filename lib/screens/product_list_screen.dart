import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../screens/product_detail_screen.dart';
import '../screens/add_edit_product_screen.dart';
import '../screens/review_list_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final Color actionColor = const Color(0xFFF48FB1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDE8F0),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : RefreshIndicator(
        onRefresh: provider.fetchProducts,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.products.length,
          itemBuilder: (context, i) {
            final p = provider.products[i];

            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                title: Text(
                  p.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Price: \$${p.price.toStringAsFixed(2)}\n${p.description}',
                  style: const TextStyle(fontSize: 14),
                ),
                isThreeLine: true,

                /// 👉 TAP CARD → DETAIL PRODUK
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(product: p),
                    ),
                  );
                },

                /// 👉 ACTION BUTTONS
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// ⭐ REVIEW
                    IconButton(
                      icon: const Icon(Icons.reviews),
                      color: actionColor,
                      tooltip: 'View Reviews',
                      onPressed: () {
                        if (p.id == null) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ReviewListScreen(productId: p.id!),
                          ),
                        );
                      },
                    ),

                    /// ✏️ EDIT
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: actionColor,
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddEditProductScreen(product: p),
                          ),
                        );
                        provider.fetchProducts();
                      },
                    ),

                    /// 🗑 DELETE
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: actionColor,
                      onPressed: () async {
                        final confirm =
                        await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title:
                            const Text('Delete Product'),
                            content: Text(
                                'Delete "${p.name}" ?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context, false),
                                child:
                                const Text('Cancel'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton
                                    .styleFrom(
                                  backgroundColor:
                                  actionColor,
                                ),
                                onPressed: () =>
                                    Navigator.pop(
                                        context, true),
                                child:
                                const Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await provider
                              .deleteProduct(p.id!);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      /// ➕ ADD PRODUCT
      floatingActionButton: FloatingActionButton(
        backgroundColor: actionColor,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditProductScreen(),
            ),
          );
          provider.fetchProducts();
        },
      ),
    );
  }
}
