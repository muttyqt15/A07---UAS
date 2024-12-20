import 'dart:convert';
import 'package:http/http.dart' as http;

class ThreadService {
  final String baseUrl = 'http://localhost:8000/api';

  // Fetch all threads
  Future<List<dynamic>> fetchThreads() async {
    final response = await http.get(Uri.parse('$baseUrl/thread/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load threads');
    }
  }


  // Like a thread
  Future<Map<String, dynamic>> likeThread(int threadId) async {
    final response =
        await http.post(Uri.parse('$baseUrl/thread/$threadId/like'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to like thread');
    }
  }

  // Delete a thread
  Future<bool> deleteThread(int threadId) async {
    final response = await http.delete(Uri.parse('$baseUrl/thread/$threadId'));
    return response.statusCode == 200;
  }

  // Edit a thread
  Future<bool> editThread(
      int threadId, String content, String? imagePath) async {
    final uri = Uri.parse('$baseUrl/thread/$threadId/edit');
    final request = http.MultipartRequest('POST', uri)
      ..fields['content'] = content;

    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    final response = await request.send();
    return response.statusCode == 200;
  }

  // Fetch thread details with comments
  Future<Map<String, dynamic>> fetchThreadDetails(int threadId) async {
    final response = await http.get(Uri.parse('$baseUrl/thread/$threadId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load thread details');
    }
  }

  // Add a comment
  Future<bool> addComment(int threadId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/thread/$threadId/comment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'content': content}),
    );
    return response.statusCode == 200;
  }

  // Delete a comment
  Future<bool> deleteComment(int commentId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/comment/$commentId'));
    return response.statusCode == 200;
  }

  // Like a comment
  Future<Map<String, dynamic>> likeComment(int commentId) async {
    final response =
        await http.post(Uri.parse('$baseUrl/comment/$commentId/like'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to like comment');
    }
  }
}
