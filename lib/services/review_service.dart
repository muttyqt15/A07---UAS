import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class ReviewService {
  final String baseUrl = 'http://localhost:8000/review/flutter';

  // Create a new review with image support
  Future<bool> createReview({
    required int restaurantId,
    required String title,
    required String content,
    required int rating,
    List<File>? images,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/create/');
      final request = http.MultipartRequest('POST', url)
        ..fields['restoran_id'] = restaurantId.toString()
        ..fields['judul_ulasan'] = title
        ..fields['teks_ulasan'] = content
        ..fields['penilaian'] = rating.toString();

      // Attach images if any
      if (images != null) {
        for (var image in images) {
          final multipartFile = await http.MultipartFile.fromPath('images', image.path);
          request.files.add(multipartFile);
        }
      }

      final response = await request.send();
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final decoded = json.decode(responseBody);
        if (decoded['status'] == 'success') {
          return true;
        } else {
          throw Exception('Failed to create review: ${decoded['message'] ?? "Unknown error"}');
        }
      } else {
        throw Exception('Error creating review: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating review: $e');
    }
  }

  // Edit an existing review
  Future<bool> editReview({
    required String reviewId,
    String? title,
    String? content,
    int? rating,
  }) async {
    try {
      final requestBody = {
        "judul_ulasan": title,
        "teks_ulasan": content,
        "penilaian": rating?.toString(),
      }..removeWhere((key, value) => value == null);

      final response = await http.post(
        Uri.parse('$baseUrl/edit/$reviewId/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == 'success') {
          return true;
        } else {
          throw Exception('Failed to edit review: ${decoded['message'] ?? "Unknown error"}');
        }
      } else {
        throw Exception('Error editing review: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error editing review: $e');
    }
  }

  // Delete a review with CSRF token and session cookie
  Future<bool> deleteReview(String reviewId, String csrfToken, String sessionId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/review/flutter/delete/$reviewId/'),
        headers: {
          'Content-Type': 'application/json',
          'X-CSRFToken': csrfToken,
          'Cookie': 'sessionid=$sessionId',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == 'success') {
          return true;
        } else {
          throw Exception('Failed to delete review: ${decoded['message']}');
        }
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You are not authorized to delete this review.');
      } else if (response.statusCode == 404) {
        throw Exception('Review not found.');
      } else {
        throw Exception('Error deleting review: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting review: $e');
    }
  }
  



  // Like/Unlike a review
  Future<Map<String, dynamic>> likeReview(String reviewId) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/like/$reviewId/'));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == 'success') {
          return decoded;
        } else {
          throw Exception('Failed to like/unlike review: ${decoded['message'] ?? "Unknown error"}');
        }
      } else {
        throw Exception('Error liking/unliking review: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error liking/unliking review: $e');
    }
  }
}
