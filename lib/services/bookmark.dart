// import 'package:flutter/material.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:uas/main.dart';

// import '../models/bookmark.dart';

// class BookmarkProvider {
//   List<Bookmark> _bookmarks = [];

//   List<Bookmark> get bookmarks => _bookmarks;

//   Future<void> fetchBookmarks(CookieRequest request) async {
//     final url = '${CONSTANTS.baseUrl}/bookmark/bookmarks/';
//     final response = await request.get(url);

//     if (response.containsKey('bookmarks')) {
//       final List<dynamic> data = response['bookmarks'];
//       final newBookmarks = data.map((item) => Bookmark.fromJson(item)).toList();

//       // Check if the new data is different
//       if (_bookmarks.length != newBookmarks.length) {
//         _bookmarks = newBookmarks;
//         // notifyListeners();
//       }
//     }
//   }

//   Future<void> toggleBookmark(int restaurantId, CookieRequest request) async {
//     final url = '${CONSTANTS.baseUrl}/bookmark/toggle/$restaurantId/';
//     final response = await request.post(url, {});

//     if (response['status'] == 'added' || response['status'] == 'removed') {
//       await fetchBookmarks(request); // Refresh bookmarks
//     } else {
//       throw Exception('Failed to toggle bookmark');
//     }
//   }

//   Future<void> removeBookmark(CookieRequest request, int bookmarkId) async {
//     try {
//       final url = '${CONSTANTS.baseUrl}/bookmark/delete/$bookmarkId/';
//       final response = await request.post(url, {});

//       // Check if the deletion was successful
//       if (response['status'] == 'success') {
//         // Remove the bookmark from the local list
//         _bookmarks.removeWhere((bookmark) => bookmark.id == bookmarkId);
//         // notifyListeners();
//       } else {
//         throw Exception('Failed to remove bookmark');
//       }
//     } catch (e) {
//       print('Error removing bookmark: $e');
//       rethrow;
//     }
//   }
// }

import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/bookmark.dart';

class BookmarkService {
  static const String baseUrl = "http://localhost:8000";

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
    final String url = 'http://localhost:8000/bookmark/delete/$bookmarkId/';
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
  static Future<Map<String, dynamic>> toggleBookmark(CookieRequest request, int restaurantId) async {
    final String url = '$baseUrl/bookmark/toggle/$restaurantId/';

    try {
      final response = await request.post(url, {});

      // Ensure the response contains valid data
      if (response.containsKey('status')) {
        return response; // Example: {'status': 'added', 'is_favorited': true, 'message': 'Bookmark added successfully!'}
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      throw Exception('Failed to toggle bookmark: $e');
    }
  }


}

