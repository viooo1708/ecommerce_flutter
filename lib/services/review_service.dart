import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/review.dart';

class ReviewService {
  static const String baseUrl = 'http://10.0.2.2:5002';

  /// Get all reviews for a product
  Future<List<Review>> getReviews(int productId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/reviews/$productId'),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(res.body);
      // Cek apakah ada 'data', kalau tidak pakai jsonData langsung
      final List<dynamic> reviewsJson =
          (jsonData['data'] as List<dynamic>?) ?? [jsonData];
      return reviewsJson.map((e) => Review.fromJson(e)).toList();
    } else {
      print('GET /reviews failed: ${res.body}');
      throw Exception('Failed to fetch reviews: ${res.statusCode}');
    }
  }

  /// Create new review
  Future<Review> createReview(
      int productId,
      String review,
      int rating,
      ) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/review'),
    );

    request.fields['product_id'] = productId.toString();
    request.fields['review_text'] = review;
    request.fields['rating'] = rating.toString();

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(body);
      return Review.fromJson(json['data'] ?? json);
    }

    throw Exception('Failed to create review');
  }



  /// Update existing review
  Future<Review> updateReview(int id, String review, int rating) async {
    final res = await http.put(
      Uri.parse('$baseUrl/review/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'review_text': review,
        'rating': rating,
      }),
    );

    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      return Review.fromJson(jsonData['data'] ?? jsonData);
    }
    throw Exception('Failed to update review');
  }

  /// Delete review
  Future<void> deleteReview(int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/review/$id'),
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Failed to delete review');
    }
  }
}
