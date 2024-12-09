import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '/models/news.dart';
import 'package:http/http.dart' as http;

class NewsOwnerServices {
  static const String baseUrl = 'http://localhost:8000';

  // Fetch list of news
  Future<List<News>> fetchNews(CookieRequest request) async {
    const url = '$baseUrl/news/show_berita_by_owner/';
    try {
      final response = await request.get(url);
      final List<dynamic> data = response;
      return data.map((json) => News.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching berita: $e');
    }
  }

  // Add new news
  Future<void> addNews(
    CookieRequest request, {
    required String title,
    required String content,
  }) async {
    const url = '$baseUrl/news/fadd_berita_ajax/';
    final body = {
      'judul': title,
      'konten': content,
    };

    try {
      final response = await request.postJson(url, jsonEncode(body));
      print('Response: $response');
      if (response['status'] != 200) {
        throw Exception('Failed to add news: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Error adding news: $e');
    }
  }


  // Edit news
  Future<void> editNews(
    CookieRequest request, {
    required String id,
    required String title,
    required String content,
  }) async {
    final url = '$baseUrl/news/fedit_berita/$id/';
    final body = {
      'judul': title, 
      'konten': content,
    };

    try {
      final response = await request.postJson(url, jsonEncode(body));
      print('Response: $response');
      // Periksa respons server
      if (response['status'] != 200) {
        throw Exception('Failed to edit news: ${response['message']}');
      }
    } catch (e) {
      throw Exception('Error editing news: $e');
    }
  }

  // Delete news
  Future<void> deleteNews(CookieRequest request, String id) async {
    final url = '$baseUrl/news/fdelete_berita/$id/';
    try {
      final response = await request.get(url);
      print('Response: $response');
      // Periksa apakah respons adalah JSON
      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] != 200) {
          throw Exception('Error from server: ${response['message']}');
        }
      } else if (response == null) {
        return;
      } else {
        throw Exception('Unexpected response: $response');
      }
    } catch (e) {
      throw Exception('Error deleting news: $e');
    }
  }



  // Toggle like
  Future<Map<String, dynamic>> toggleLike(
    CookieRequest request, String beritaId) async {
  final url = '$baseUrl/news/flike_berita/$beritaId/';
  try {
    // Gunakan postJson untuk mengirim body kosong dengan Content-Type JSON
    final response = await request.postJson(url, jsonEncode({})); // Pastikan body adalah valid JSON
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
