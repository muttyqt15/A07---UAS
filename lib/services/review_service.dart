// lib/services/review_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uas/models/review.dart';

class ReviewService {
  final String baseUrl = 'http://localhost:8000/api'; // Ganti dengan URL backend Anda

  // Fetch all reviews
  Future<List<Review>> fetchReviews() async {
    final response = await http.get(Uri.parse('$baseUrl/reviews/'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Review> reviews = body.map((dynamic item) => Review.fromJson(item)).toList();
      return reviews;
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  // Create a new review
  Future<Review> createReview(Review review) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reviews/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(review.toJson()),
    );

    if (response.statusCode == 201) {
      return Review.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create review');
    }
  }

  // Update an existing review
  Future<Review> updateReview(Review review) async {
    final response = await http.put(
      Uri.parse('$baseUrl/reviews/${review.id}/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(review.toJson()),
    );

    if (response.statusCode == 200) {
      return Review.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update review');
    }
  }

  // Delete a review
  Future<void> deleteReview(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/reviews/$id/'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete review');
    }
  }
}
