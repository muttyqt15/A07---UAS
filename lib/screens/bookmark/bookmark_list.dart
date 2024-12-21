import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/bookmark.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class BookmarkListScreen extends StatefulWidget {
  @override
  _BookmarkListScreenState createState() => _BookmarkListScreenState();
}

class _BookmarkListScreenState extends State<BookmarkListScreen> {
  bool _isLoading = false;

  Future<void> _removeBookmark(BuildContext context, BookmarkProvider provider,
      CookieRequest request, int bookmarkId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await provider.removeBookmark(request, bookmarkId);

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bookmark removed successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove bookmark: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context);
    final provider = Provider.of<BookmarkProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background with batik image and black overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/batik.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Slight black mask
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bookmarked Restaurants Section
                  Card(
                    color: const Color(0xFF5F4D40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bookmarked Restaurants",
                            style: TextStyle(
                              fontFamily: 'CrimsonPro',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Daftar Restoran yang Telah Anda Bookmark",
                            style: TextStyle(
                              fontFamily: 'CrimsonPro',
                              fontSize: 14,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bookmarks List
                  const Text(
                    "Daftar Bookmark",
                    style: TextStyle(
                      fontFamily: 'CrimsonPro',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder(
                    future: provider.fetchBookmarks(request),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading bookmarks: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : provider.bookmarks.isEmpty
                              ? const Text(
                                  "No bookmarked restaurants.",
                                  style: TextStyle(color: Colors.white),
                                )
                              : Column(
                                  children: provider.bookmarks.map((bookmark) {
                                    return Card(
                                      color: const Color(0xFF5F4D40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    bookmark.name,
                                                    style: const TextStyle(
                                                      fontFamily: 'CrimsonPro',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    bookmark.address,
                                                    style: const TextStyle(
                                                      fontFamily: 'CrimsonPro',
                                                      fontSize: 14,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Optional: Add an icon or additional action
                                            IconButton(
                                              icon: const Icon(
                                                Icons.bookmark_remove,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                // Show confirmation dialog
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Remove Bookmark'),
                                                      content: const Text(
                                                          'Are you sure you want to remove this bookmark?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            _removeBookmark(
                                                                context,
                                                                provider,
                                                                request,
                                                                bookmark.id);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                          child: const Text(
                                                              'Remove'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
