  import 'package:flutter/material.dart';
  import '../models/review.dart';
  import '../services/review_service.dart';

  class ReviewProvider extends ChangeNotifier {
    final ReviewService _service = ReviewService();

    List<Review> _reviews = [];
    List<Review> get reviews => _reviews;

    bool _loading = false;
    bool get loading => _loading;

    String? _error;
    String? get error => _error;

    /// Fetch reviews by productId
    Future<void> fetchReviews(int productId) async {
      _loading = true;
      _error = null;
      notifyListeners();

      try {
        final fetched = await _service.getReviews(productId);
        _reviews = fetched;
      } catch (e) {
        _error = e.toString();
        _reviews = [];
      } finally {
        _loading = false;
        notifyListeners();
      }
    }

    /// Add new review
    Future<void> addReview({
      required int productId,
      required String review,
      required int rating,
    }) async {
      try {
        await _service.createReview(productId, review, rating);
        await fetchReviews(productId); // ✅ WAJIB
      } catch (e) {
        _error = e.toString();
        notifyListeners();
        rethrow;
      }
    }


    /// Update existing review
    Future<void> updateReview(Review review) async {
      try {
        final updatedReview =
        await _service.updateReview(review.id, review.review, review.rating);
        final index = _reviews.indexWhere((r) => r.id == review.id);
        if (index != -1) {
          _reviews[index] = updatedReview;
          notifyListeners();
        }
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }

    /// Delete review
    Future<void> deleteReview(int reviewId) async {
      try {
        await _service.deleteReview(reviewId);
        _reviews.removeWhere((r) => r.id == reviewId);
        notifyListeners();
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }

    /// Clear error
    void clearError() {
      _error = null;
      notifyListeners();
    }
  }
