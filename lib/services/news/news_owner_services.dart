import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '/models/news.dart';

class NewsOwnerServices {
  static const String baseUrl = 'http://localhost:8000';

  // Fetch list of news
  Future<List<News>> fetchNews(CookieRequest request) async {
    const url = '$baseUrl/news/show_berita_by_owner/';
    try {
      final response = await request.get(url);
      // print('Raw response: $response');
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
    File? imageFile, // For mobile/desktop
    Uint8List? imageBytes, // For web
  }) async {
    final String url = '$baseUrl/news/fadd_berita_ajax/';

    Map<String, String> fields = {'judul': title, 'konten': content};

    try {
      if (imageFile != null) {
        // if (await imageFile.exists()) {
        //   Map<String, File> files = {'gambar': imageFile};
        //   // Multipart request with file
        //   final response = await request.postMultipart(url, fields, files);
        //   if (response['status'] != 200) {
        //     throw Exception('Failed to add news: ${response['message']}');
        //   }
        //   print("DEBUG: News successfully added with file.");
        // } else {
        //   throw Exception('Image file does not exist.');
        // }

        final response = await request.post(url, fields);
        if (response['status'] != 200) {
          throw Exception('Failed to edit news: ${response['message']}');
        }
        print("DEBUG: News successfully edited with base64 image.");
      } else if (imageBytes != null) {
        // Encode Uint8List to base64
        String base64Image = base64Encode(imageBytes);
        fields['gambar_base64'] = base64Image;
        // POST request with base64 image
        final response = await request.post(url, fields);
        if (response['status'] != 200) {
          throw Exception('Failed to add news: ${response['message']}');
        }
        print("DEBUG: News successfully added with base64 image.");
      } else {
        throw Exception('No image provided.');
      }
    } catch (e) {
      print("ERROR: Failed to add news: $e");
      rethrow;
    }
  }

Future<void> editNews(
    CookieRequest request, {
    required String id,
    required String title,
    required String content,
    File? imageFile, // Untuk mobile/desktop
    Uint8List? imageBytes, // Untuk web
  }) async {
    final String url = '$baseUrl/news/fedit_berita/$id/';
    Map<String, String> fields = {'judul': title, 'konten': content};

    try {
      if (imageFile != null) {
        // if (await imageFile.exists()) {
        //   Map<String, File> files = {'gambar': imageFile};
        //   // Multipart request dengan file
        //   final response = await request.postMultipart(url, fields, files);
        //   if (response['status'] != 200) {
        //     throw Exception('Failed to edit news: ${response['message']}');
        //   }
        //   print("DEBUG: News successfully edited with file.");
        // } else {
        //   throw Exception('Image file does not exist.');
        // }

        final response = await request.post(url, fields);
        if (response['status'] != 200) {
          throw Exception('Failed to edit news: ${response['message']}');
        }
        print("DEBUG: News successfully edited with base64 image.");
      } else if (imageBytes != null) {
        // Encode Uint8List ke base64
        String base64Image = base64Encode(imageBytes);
        fields['gambar_base64'] = base64Image;
        // POST request dengan base64
        final response = await request.post(url, fields);
        if (response['status'] != 200) {
          throw Exception('Failed to edit news: ${response['message']}');
        }
        print("DEBUG: News successfully edited with base64 image.");
      } else {
        // Jika tidak ada gambar baru
        final response = await request.post(url, fields);
        if (response['status'] != 200) {
          throw Exception('Failed to edit news: ${response['message']}');
        }
        print("DEBUG: News successfully edited without new image.");
      }
    } catch (e) {
      print("ERROR: Failed to edit news: $e");
      rethrow;
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
      final response = await request.postJson(
          url, jsonEncode({})); // Pastikan body adalah valid JSON
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
