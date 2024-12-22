import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:uas/main.dart';

import '../models/bookmark.dart';

class BookmarkProvider {
  List<Bookmark> _bookmarks = [];

  List<Bookmark> get bookmarks => _bookmarks;

  Future<void> fetchBookmarks(CookieRequest request) async {
    const url = '${CONSTANTS.baseUrl}/bookmark/bookmarks/';
    final response = await request.get(url);

    if (response.containsKey('bookmarks')) {
      final List<dynamic> data = response['bookmarks'];
      final newBookmarks = data.map((item) => Bookmark.fromJson(item)).toList();

      // Check if the new data is different
      if (_bookmarks.length != newBookmarks.length) {
        _bookmarks = newBookmarks;
        // notifyListeners();
      }
    }
  }

  Future<void> toggleBookmark(int restaurantId, CookieRequest request) async {
    final url = '${CONSTANTS.baseUrl}/bookmark/toggle/$restaurantId/';
    final response = await request.post(url, {});

    if (response['status'] == 'added' || response['status'] == 'removed') {
      await fetchBookmarks(request); // Refresh bookmarks
    } else {
      throw Exception('Failed to toggle bookmark');
    }
  }

  Future<void> removeBookmark(CookieRequest request, int bookmarkId) async {
    try {
      final url = '${CONSTANTS.baseUrl}/bookmark/delete/$bookmarkId/';
      final response = await request.post(url, {});

      // Check if the deletion was successful
      if (response['status'] == 'success') {
        // Remove the bookmark from the local list
        _bookmarks.removeWhere((bookmark) => bookmark.id == bookmarkId);
        // notifyListeners();
      } else {
        throw Exception('Failed to remove bookmark');
      }
    } catch (e) {
      rethrow;
    }
  }
}
