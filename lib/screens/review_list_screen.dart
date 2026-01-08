import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';
import 'add_review_screen.dart';

class ReviewListScreen extends StatefulWidget {
  final int productId;

  const ReviewListScreen({
    super.key,
    required this.productId,
  });

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReviewProvider>().fetchReviews(widget.productId);
    });
  }

  Future<void> _openAddReview() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddReviewScreen(productId: widget.productId),
      ),
    );

    // ✅ JIKA REVIEW BERHASIL DITAMBAH → REFRESH LIST
    if (result == true) {
      context.read<ReviewProvider>().fetchReviews(widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReviewProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: Colors.pinkAccent,
      ),

      /// ✅ FLOATING BUTTON TAMBAH REVIEW
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: const Icon(Icons.add),
        onPressed: _openAddReview,
      ),

      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(
        child: Text(
          provider.error!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : provider.reviews.isEmpty
          ? const Center(
        child: Text(
          'No reviews yet',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: provider.reviews.length,
        itemBuilder: (context, i) {
          final r = provider.reviews[i];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(r.review),
              subtitle: Row(
                children: List.generate(
                  r.rating,
                      (_) => const Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
