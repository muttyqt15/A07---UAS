import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import "dart:io";

import 'package:uas/main.dart';

class ThreadService {
  // final String baseUrl = 'http://10.0.2.2:8000';
  final String baseUrl = CONSTANTS.baseUrl;
  final CookieRequest request;

  ThreadService({required this.request});

  // Utility function to handle HTTP responses with messages
  Future<Map<String, dynamic>> _handleResponse(
      Future<Map<String, dynamic>> response) async {
    try {
      final res = await response;
      if (res.containsKey('error')) {
        return {
          'message': res['error'],
          'data': null,
          'success': false,
        };
      }
      return {
        'message':
            'Success!${res['message'] != null ? ' ${res['message']}' : ''}',
        'data': res,
        'success': true,
      };
    } catch (e) {
      return {
        'message': 'An error occurred: $e',
        'data': null,
        'success': false,
      };
    }
  }

  // Create thread with optional image
  Future<Map<String, dynamic>> createThread(
      String content, File? selectedImage) async {
    String? base64Image;

    if (selectedImage != null) {
      List<int> imageBytes = await selectedImage.readAsBytes();
      base64Image =
          "data:image/${selectedImage.path.split('.').last};base64,${base64Encode(imageBytes)}";
    }

    final data = {
      "content": content,
      "image": base64Image,
    };

    // Ensure the response is cast to the correct type
    final response = await request.postJson(
      '$baseUrl/thread/fcreate/',
      jsonEncode(data),
    );

    return _handleResponse(Future.value(response));
  }

  // Fetch threads from the server
  Future<Map<String, dynamic>> fetchThreads() async {
    // Ensure the response is cast to the correct type
    final response = await request.get("$baseUrl/thread/fget_thread/");
    print(response);
    return _handleResponse(Future.value(response));
  }

  // Edit an existing thread
  Future<Map<String, dynamic>> editThread(
      int threadId, String newContent) async {
    final data = {
      'content': newContent,
    };

    final response = await request.postJson(
      '$baseUrl/thread/$threadId/fedit/',
      jsonEncode(data),
    );
    return _handleResponse(Future.value(response));
  }

  // Delete a thread
  Future<Map<String, dynamic>> deleteThread(int threadId) async {
    // Ensure the response is cast to the correct type
    final response = await request.post(
      '$baseUrl/thread/$threadId/fdelete/',
      {},
    );
    return _handleResponse(Future.value(response));
  }

  // Like a thread
  Future<Map<String, dynamic>> likeThread(int threadId) async {
    // Ensure the response is cast to the correct type
    final response = await request.post(
      "$baseUrl/thread/$threadId/flike/",
      jsonEncode({}),
    );
    return _handleResponse(Future.value(response));
  }

  // For thread details page
  Future<Map<String, dynamic>> fetchDetailThread(int threadId) async {
    // Ensure the response is cast to the correct type
    final response = await request.get(
      "$baseUrl/thread/fget_thread/$threadId/",
    );
    return _handleResponse(Future.value(response));
  }

  // Add a comment to a thread (new endpoint)
  Future<Map<String, dynamic>> addComment(int threadId, String content) async {
    final data = {
      'content': content,
    };

    final response = await request.postJson(
      '$baseUrl/thread/$threadId/fcomment/',
      jsonEncode(data),
    );
    return _handleResponse(Future.value(response));
  }

  // Like a comment (new endpoint)
  Future<Map<String, dynamic>> likeComment(int commentId) async {
    final response = await request.post(
      "$baseUrl/comment/$commentId/comment/flike/",
      jsonEncode({}),
    );
    return _handleResponse(Future.value(response));
  }

  // Delete a comment (new endpoint)
  Future<Map<String, dynamic>> deleteComment(int commentId) async {
    final response = await request.post(
      "$baseUrl/thread/$commentId/comment/fdelete/",
      {},
    );
    return _handleResponse(Future.value(response));
  }
}
