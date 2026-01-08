import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../providers/review_provider.dart';

class ReviewScreen extends StatefulWidget {
  final List<Product> products; // List produk yang bisa direview

  const ReviewScreen({super.key, required this.products});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  Product? _selectedProduct;
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    if (widget.products.isNotEmpty) {
      _selectedProduct = widget.products.first;
      _fetchReviews();
    }
  }

  void _fetchReviews() {
    if (_selectedProduct != null) {
      context.read<ReviewProvider>().fetchReviews(_selectedProduct!.id!);
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _addReview() async {
    if (_selectedProduct == null || _reviewController.text.isEmpty) return;

    try {
      await context.read<ReviewProvider>().addReview(
        productId: _selectedProduct!.id!,
        review: _reviewController.text,
        rating: _rating,
      );

      _reviewController.clear();
      setState(() => _rating = 5);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review added')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReviewProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Reviews'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
        children: [
          // Dropdown pilih produk
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton<Product>(
              value: _selectedProduct,
              isExpanded: true,
              hint: const Text('Select Product'),
              items: widget.products
                  .map((p) => DropdownMenuItem(
                value: p,
                child: Text(p.name),
              ))
                  .toList(),
              onChanged: (p) {
                setState(() => _selectedProduct = p);
                _fetchReviews();
              },
            ),
          ),

          // List review
          Expanded(
            child: provider.loading
                ? const Center(child: CircularProgressIndicator())
                : provider.error != null
                ? Center(
              child: Text(
                'Error: ${provider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            )
                : provider.reviews.isEmpty
                ? const Center(
              child: Text(
                'No reviews found',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: provider.reviews.length,
              itemBuilder: (_, i) {
                final r = provider.reviews[i];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    title: Text(r.review),
                    subtitle: Row(
                      children: List.generate(
                        r.rating,
                            (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input review
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Add a review',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _rating,
                  items: [1, 2, 3, 4, 5]
                      .map((e) => DropdownMenuItem(value: e, child: Text('$e')))
                      .toList(),
                  onChanged: (v) => setState(() => _rating = v ?? 5),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pinkAccent),
                  onPressed: _addReview,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
