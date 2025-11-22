import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/review_service.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';

class ReviewScreen extends StatefulWidget {
  final int productId;

  const ReviewScreen({Key? key, required this.productId}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final ReviewService _reviewService = ReviewService();
  late Future<List<Review>> _reviews;
  int _currentIndex = 1; // Optional jika ingin bottom navbar

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() {
    setState(() {
      _reviews = _reviewService.getReviewsForProduct(widget.productId);
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProductListScreen()),
        );
        break;
      case 1:
      // Tetap di Review
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CartScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Reviews', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 2,
      ),
      body: FutureBuilder<List<Review>>(
        future: _reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No reviews yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final reviews = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];

              return Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showReviewDetailDialog(context, review),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rating badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.green[700],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            review.rating.toString(),
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Review text + stars
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.review,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < review.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  );
                                }),
                              ),
                            ],
                          ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add),
        onPressed: () => _showAddReviewDialog(context),
      ),
      // BottomNavigationBar jika ingin konsisten seperti ProductListScreen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        selectedFontSize: 14,
        unselectedFontSize: 13,
        onTap: _onTabTapped,
        backgroundColor: Colors.white,
        elevation: 6,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag, size: 26),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reviews, size: 26),
            label: 'Review',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 26),
            label: 'User',
          ),
        ],
      ),
    );
  }

  // ======================
  // ADD REVIEW DIALOG
  // ======================
  void _showAddReviewDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _reviewController = TextEditingController();
    int _rating = 3;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Add Review"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _reviewController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Review',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (v) =>
                  v == null || v.isEmpty ? "Please enter review" : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: _rating,
                  decoration: InputDecoration(
                    labelText: "Rating",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: [1, 2, 3, 4, 5].map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text("$e Star(s)"),
                    );
                  }).toList(),
                  onChanged: (v) => _rating = v!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Submit"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _reviewService
                      .createReview(
                    productId: widget.productId,
                    review: _reviewController.text,
                    rating: _rating,
                  )
                      .then((_) {
                    Navigator.pop(context);
                    _loadReviews();
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  // ======================
  // DETAIL DIALOG
  // ======================
  void _showReviewDetailDialog(BuildContext context, Review review) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Review Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                review.review,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Close"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}
