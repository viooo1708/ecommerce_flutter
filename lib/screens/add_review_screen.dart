import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';

class AddReviewScreen extends StatefulWidget {
  final int productId;

  const AddReviewScreen({
    super.key,
    required this.productId,
  });

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final TextEditingController _controller = TextEditingController();
  int _rating = 3;
  bool _loading = false;

  Future<void> _submitReview() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review cannot be empty')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await context.read<ReviewProvider>().addReview(
        productId: widget.productId,
        review: _controller.text,
        rating: _rating,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review added successfully')),
      );

      Navigator.pop(context, true); // refresh ReviewListScreen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// REVIEW TEXT
            TextField(
              controller: _controller,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// RATING
            Row(
              children: [
                const Text('Rating:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                DropdownButton<int>(
                  value: _rating,
                  items: [1, 2, 3, 4, 5]
                      .map(
                        (e) => DropdownMenuItem(
                      value: e,
                      child: Text('$e Star'),
                    ),
                  )
                      .toList(),
                  onChanged: (v) => setState(() => _rating = v ?? 3),
                ),
              ],
            ),
            const SizedBox(height: 24),

            /// SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Submit Review',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
