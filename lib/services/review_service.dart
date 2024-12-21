import 'dart:convert';
import 'package:http/http.dart' as http;

class ReviewService {
  final String baseUrl = 'http://localhost:8000/review/flutter';

  // Fetch all reviews
  Future<List<dynamic>> fetchReviews() async {
    final response = await http.get(Uri.parse('$baseUrl/list/'));
    final decoded = json.decode(response.body);

    if (response.statusCode == 200 && decoded['status'] == 'success') {
      return decoded['data'];
    } else {
      throw Exception('Failed to load reviews: ${decoded['message'] ?? response.body}');
    }
  }

  // Fetch a single review by ID
  Future<Map<String, dynamic>> fetchReviewDetails(int reviewId) async {
    final response = await http.get(Uri.parse('$baseUrl/$reviewId/'));
    final decoded = json.decode(response.body);

    if (response.statusCode == 200 && decoded['status'] == 'success') {
      return decoded['data'];
    } else {
      throw Exception('Failed to load review details: ${decoded['message'] ?? response.body}');
    }
  }

  // Create a new review
  Future<bool> createReview({
    required int restaurantId,
    required String title,
    required String content,
    required int rating,
    List<String>? images, 
  }) async {
    final requestBody = {
      "restoran_id": restaurantId,
      "judul_ulasan": title,
      "teks_ulasan": content,
      "penilaian": rating,
      "images": images ?? [],
    };

    final response = await http.post(
      Uri.parse('$baseUrl/create/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded['status'] == 'success') {
      return true;
    } else {
      throw Exception('Failed to create review: ${decoded['message'] ?? response.body}');
    }
  }

  // Edit an existing review (now using POST)
  Future<bool> editReview({
    required int reviewId,
    String? title,
    String? content,
    int? rating,
  }) async {
    final requestBody = {
      "judul_ulasan": title,
      "teks_ulasan": content,
      "penilaian": rating,
    }..removeWhere((key, value) => value == null); // Remove null fields

    final response = await http.post(
      Uri.parse('$baseUrl/edit/$reviewId/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded['status'] == 'success') {
      return true;
    } else {
      throw Exception('Failed to edit review: ${decoded['message'] ?? response.body}');
    }
  }

  // Delete a review
  Future<bool> deleteReview(int reviewId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete/$reviewId/'),
      headers: {'Content-Type': 'application/json'},
    );

    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded['status'] == 'success') {
      return true;
    } else {
      throw Exception('Failed to delete review: ${decoded['message'] ?? response.body}');
    }
  }

  // Like/Unlike a review
  Future<Map<String, dynamic>> likeReview(int reviewId) async {
    final response = await http.post(Uri.parse('$baseUrl/like/$reviewId/'));
    final decoded = json.decode(response.body);
    if (response.statusCode == 200 && decoded['status'] == 'success') {
      return decoded;
    } else {
      throw Exception('Failed to like/unlike review: ${decoded['message'] ?? response.body}');
    }
  }
}
