import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:uas/main.dart';
import '/models/news.dart';

class NewsServices {
  // Fetch list of berita
  Future<List<News>> fetchBerita(CookieRequest request) async {
    const url = '${CONSTANTS.baseUrl}/news/show_berita_json/';
    try {
      final response = await request.get(url);
      // print('Raw response: $response'); 
      final List<dynamic> data = response;
      return data.map((json) => News.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching berita: $e');
    }
  }

  // Fetch single berita by ID
    Future<News> fetchBeritaById(CookieRequest request, String beritaId) async {
      final url = '${CONSTANTS.baseUrl}/news/fshow_berita_id/$beritaId/';
      try {
        final response = await request.get(url);
        // print('Raw response for berita by ID: $response');
        return News.fromJson(
            response); // Assume the response is a single berita object
      } catch (e) {
        throw Exception('Error fetching berita by ID: $e');
      }
    }


  // Toggle like for a berita
  Future<Map<String, dynamic>> toggleLike(
      CookieRequest request, String beritaId) async {
    final url = '${CONSTANTS.baseUrl}/news/like_berita/$beritaId/';
    try {
      // Gunakan postJson untuk mengirimkan request kosong
      final response = await request.postJson(url, jsonEncode({}));
      if (response['status'] == 200 || response['status'] == true) {
        return response;
      } else {
        throw Exception('Failed to toggle like: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Error toggling like: $e');
    }
  }
  
}
