import 'package:flutter/material.dart';
import '../models/review.dart';
import '../services/review_service.dart';
import 'add_review_screen.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';

class AllReviewsScreen extends StatefulWidget {
  const AllReviewsScreen({Key? key}) : super(key: key);

  @override
  _AllReviewsScreenState createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  final ReviewService _reviewService = ReviewService();
  late Future<List<Review>> _allReviews;
  int _currentIndex = 1; // Review tab

  @override
  void initState() {
    super.initState();
    _loadAllReviews();
  }

  void _loadAllReviews() {
    setState(() {
      _allReviews = _reviewService.getReviews();
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
          MaterialPageRoute(builder: (context) => ProductListScreen()),
        );
        break;
      case 1:
        break; // tetap di halaman Review
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDE8F0), // pink pastel background
      appBar: AppBar(
        title: const Text('All Reviews', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8BBD0), // pink pastel
        elevation: 2,
      ),
      body: FutureBuilder<List<Review>>(
        future: _allReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No reviews available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey)));
          }

          final reviews = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return InkWell(
                onTap: () => _showReviewDetailDialog(context, review),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFF48FB1), // pink pastel
                      foregroundColor: Colors.white,
                      child: Text(
                        review.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      review.review,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('Product ID: ${review.productId}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (i) {
                        return Icon(
                          i < review.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        );
                      }),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReviewScreen()),
          );
          if (result == true) {
            _loadAllReviews();
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Review',
        backgroundColor: const Color(0xFFF48FB1), // pink pastel
      ),
    );
  }

  void _showReviewDetailDialog(BuildContext context, Review review) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Review Details (ID: ${review.id})'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Product ID: ${review.productId}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text(review.review, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Rating: ', style: TextStyle(fontSize: 14)),
                    ...List.generate(5, (i) {
                      return Icon(
                        i < review.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
