import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/news.dart';

class NewsServices {
  static const String baseUrl =
      'http://127.0.0.1:8000'; // Update to your server address

  // Fetch list of berita
  Future<List<News>> fetchBerita() async {
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

  // Toggle like for a berita
  Future<void> toggleLike(int beritaId) async {
    final url = Uri.parse('$baseUrl/news/like_berita/$beritaId/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to toggle like: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }
}
