import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '/models/news.dart';

class NewsOwnerServices {
  static const String baseUrl ='http://localhost:8000'; 
  // Fetch list of news
  Future<List<News>> fetchNews() async {
    final url = Uri.parse('$baseUrl/news/show_berita_json/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => News.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load berita: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching berita: $e');
    }
  }

  // Add new news
  Future<void> addNews(
    Map<String, dynamic> data, {
    required String title,
    required String content,
    required String imagePath,
  }) async {
    final url = Uri.parse('$baseUrl/news/create/');
    final body = {
      'title': title,
      'content': content,
      'image': imagePath,
    };

    try {
      final response =
          await http.post(url, headers: _jsonHeaders, body: jsonEncode(body));

      if (response.statusCode != 201) {
        throw Exception('Failed to add news: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding news: $e');
    }
  }

  // Edit news
  Future<void> editNews(
    Map<String, dynamic> data, {
    required int id,
    required String title,
    required String content,
    String? imagePath,
  }) async {
    final url = Uri.parse('$baseUrl/news/$id/update/');
    final body = {
      'title': title,
      'content': content,
      if (imagePath != null) 'image': imagePath,
    };

    try {
      final response =
          await http.put(url, headers: _jsonHeaders, body: jsonEncode(body));

      if (response.statusCode != 200) {
        throw Exception('Failed to update news: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating news: $e');
    }
  }

  // Delete news
  Future<void> deleteNews(String id) async {
    final url = Uri.parse('$baseUrl/news/fdelete_berita/$id/');
    try {
      final response = await http.get(url, headers: _jsonHeaders);
      if (response.statusCode != 204) {
        throw Exception('Failed to delete news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting news: $e');
    }
  }

  Future<Map<String, dynamic>> toggleLike(String beritaId) async {
    final url = Uri.parse('$baseUrl/news/like_berita/$beritaId/');
    final token = await _getAuthToken(); // Ambil token autentikasi

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Header autentikasi
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return response JSON
      } else if (response.statusCode == 403) {
        throw Exception("Unauthorized: Login required");
      } else {
        throw Exception('Failed to toggle like: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }

  Future<String> _getAuthToken() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'authToken') ?? '';
  }



  // Common headers for JSON requests
  Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
