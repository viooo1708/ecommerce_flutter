import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ReviewService {
  final String baseUrl = "http://192.168.18.65:5002";

  Future<List<Review>> getReviews() async {
    final response = await http.get(Uri.parse('$baseUrl/reviews'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Review.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load all reviews');
    }
  }

  Future<List<Review>> getReviewsForProduct(int productId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/review/product/$productId'));

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((model) => Review.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load reviews for product $productId');
    }
  }

  Future<Review> createReview({
    required int productId,
    required String review,
    required int rating,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'product_id': productId,
        'review': review,
        'rating': rating,
      }),
    );

    if (response.statusCode == 201) {
      return Review.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create review.');
    }
  }
}
