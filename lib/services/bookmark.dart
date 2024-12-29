import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:uas/main.dart';
import '../models/bookmark.dart';

class BookmarkService {
  static const String baseUrl = CONSTANTS.baseUrl;

  // Fetch bookmarks from the backend
  Future<List<Bookmark>> fetchBookmarks(CookieRequest request) async {
    const String url = '$baseUrl/bookmark/bookmarks/';
    try {
      final response = await request.get(url);

      if (response.containsKey('bookmarks')) {
        final List<dynamic> data = response['bookmarks'];
        return data.map((item) => Bookmark.fromJson(item)).toList();
      } else {
        throw Exception('Unexpected response structure');
      }
    } catch (e) {
      throw Exception('Failed to fetch bookmarks: $e');
    }
  }

  // Delete a bookmark by its ID
  static Future<bool> deleteBookmark(CookieRequest request, int bookmarkId) async {
    final String url = '$baseUrl/bookmark/delete/$bookmarkId/';
    try {
      final response = await request.post(url, {});

      if (response.containsKey('status') && response['status'] == 'success') {
        return true;
      } else {
        throw Exception(response['message'] ?? 'Unexpected error occurred.');
      }
    } catch (e) {
      throw Exception('Failed to delete bookmark: $e');
    }
  }

  // Toggle bookmark for a restaurant
  Future<Map<String, dynamic>> toggleBookmark(CookieRequest request, int restaurantId) async {
    final String url = '$baseUrl/bookmark/toggle/$restaurantId/';

    try {
      final response = await request.post(url, {});
      print(response);

      // Ensure the response contains valid data
      if (response.containsKey('status')) {
        return response; 
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      throw Exception('Failed to toggle bookmark: $e');
    }
  }
}