import 'package:flutter/material.dart';
import '../services/review_service.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({Key? key}) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _reviewController = TextEditingController();
  int _rating = 3; // Default rating

  final ReviewService _reviewService = ReviewService();

  @override
  void dispose() {
    _productIdController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate()) {
      try {
        final productId = int.parse(_productIdController.text);
        await _reviewService.createReview(
          productId: productId,
          review: _reviewController.text,
          rating: _rating,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review added successfully!')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add review: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: const Color(0xFFFDE8F0), // pink pastel lembut
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFF48FB1)), // pink pastel
      ),
      labelStyle: TextStyle(color: Colors.grey[700]),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFDE8F0), // pink pastel background
      appBar: AppBar(
        title: const Text('Add New Review', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8BBD0), // pink pastel lembut
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _productIdController,
                decoration: inputDecoration.copyWith(
                  labelText: 'Product ID',
                  hintText: 'Enter product ID',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a product ID';
                  if (int.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _reviewController,
                decoration: inputDecoration.copyWith(
                  labelText: 'Review',
                  hintText: 'Write your review here',
                ),
                maxLines: 4,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter some text' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _rating,
                decoration: inputDecoration.copyWith(labelText: 'Rating'),
                items: [1, 2, 3, 4, 5].map((rating) {
                  return DropdownMenuItem<int>(
                    value: rating,
                    child: Text('$rating Star(s)'),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => _rating = newValue!),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48FB1), // pink pastel
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Submit Review', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
