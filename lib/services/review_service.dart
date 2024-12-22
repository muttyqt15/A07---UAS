import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:uas/models/restaurant.dart';



class ReviewService {
  final CookieRequest request;
  final String baseUrl = 'http://localhost:8000/review/flutter';

  ReviewService({required this.request});

  // Fetch all restaurants
  Future<List<Restaurant>> fetchAllRestaurants() async {
    final response = await request.get('$baseUrl/all-restaurants/');
    if (response != null && response is List<dynamic>) {
      return response.map((json) {
        final fields = json['fields'];
        return Restaurant(
          id: json['pk'],
          name: fields['name'] ?? 'Unknown',
          district: fields['district'] ?? 'Unknown',
          address: fields['address'] ?? 'Unknown',
          operationalHours: fields['operational_hours'] ?? 'Unknown',
          photoUrl: fields['photo_url'] ?? '',
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  // Create Review
  Future<Map<String, dynamic>> createReview({
    required int restaurantId,
    required String title,
    required String content,
    required int rating,
    Uint8List? imageBytes,
    String? displayName,
  }) async {
    // Jika belum login, login dulu (opsional - atau tangani di luar)
    if (!request.loggedIn) {
      final loginResp = await request.login(
        'http://localhost:8000/auth/flogin/',
        {
          'username': 'testuser',
          'password': 'testpass',
        },
      );
      // Cek apakah login berhasil
      if (loginResp['status'] != 'success' && !request.loggedIn) {
        throw Exception('Gagal login sebelum membuat review: $loginResp');
      }
    }

    // Encode gambar jika ada
    String? base64Image;
    if (imageBytes != null) {
      base64Image = "data:image/jpeg;base64,${base64Encode(imageBytes)}";
    }

    // Data untuk request
    final data = {
      'restoran_id': restaurantId.toString(),
      'judul_ulasan': title,
      'teks_ulasan': content,
      'penilaian': rating.toString(),
      'display_name': displayName ?? "",
      'image_base64': base64Image,
    };

    // Kirim POST request (JSON)
    final response = await request.postJson(
      '$baseUrl/create/',
      jsonEncode(data), 
    );

    // Cek hasil response
    if (response == null) {
      throw Exception('Response null dari server.');
    }

    // Misal server balas {"status": "success", "message": "..."}
    if (response['status'] == 'success') {
      return {'success': true, 'message': response['message']};
    } else {
      return {'success': false, 'message': response['message']};
    }
  }

  // Edit an existing review
  Future<bool> editReview({
    required String reviewId, // UUID
    String? title,
    String? content,
    int? rating,
    String? newImageBase64, // Base64 string untuk gambar baru
  }) async {
    try {
      final requestBody = {
        "judul_ulasan": title,
        "teks_ulasan": content,
        "penilaian": rating?.toString(),
        "new_image_base64": newImageBase64, // Tambahkan gambar baru jika ada
      }..removeWhere((key, value) => value == null);

      final response = await request.postJson(
        "$baseUrl/edit/$reviewId/", // Gunakan UUID
        requestBody,
      );

      if (response["status"] == "success") {
        return true;
      } else {
        throw Exception('Failed to edit review: ${response["message"]}');
      }
    } catch (e) {
      throw Exception('Error editing review: $e');
    }
  }


  // Delete a review with CSRF token and session cookie
  Future<bool> deleteReview(String reviewId, String csrfToken, String sessionId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete/$reviewId/'),
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
}
