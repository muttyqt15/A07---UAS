import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
// import 'package:uas/services/thread.dart';

class ThreadScreen extends StatefulWidget {
  const ThreadScreen({Key? key}) : super(key: key);

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  List<dynamic> threads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchThreads();
  }

  String? imagePath;
  String _content = "";

  Future<void> createThread(request) async {
    try {
      final data = {"content": _content};
      final response = await request.postJson(
          'http://localhost:8000/thread/fcreate/', jsonEncode(data));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      fetchThreads(); // Refresh threads

      setState(() {
        _content = "";
        imagePath = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create thread: $e')),
      );
    }
  }

  Future<void> fetchThreads() async {
    final request = context.read<CookieRequest>();
    try {
      final res =
          await request.get("http://localhost:8000/thread/fget_thread/");

      print('Raw response: $res'); // Debug print

      setState(() {
        // Adjust based on actual response structure
        // For example:
        threads = res['threads'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Error details: $e'); // More detailed error logging
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch threads: $e')),
      );
    }
  }

  Future<void> editThread(int threadId, String newContent) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.postJson(
        'http://localhost:8000/thread/$threadId/fedit/',
        jsonEncode({
          'content': newContent,
        }),
      );

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response['message'] ?? 'Thread updated successfully')),
        );
      }

      // Refresh threads after editing
      await fetchThreads();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to edit thread: $e')),
        );
      }
    }
  }

  Future<void> deleteThread(int threadId) async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request
          .post('http://localhost:8000/thread/$threadId/fdelete/', {});

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response['message'] ?? 'Thread deleted successfully')),
        );
      }

      // Refresh threads after deletion
      await fetchThreads();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete thread: $e')),
        );
      }
    }
  }

  Future<void> likeThread(int threadId) async {
    final request = context.watch<CookieRequest>();
    try {
      await request.post(
          "http://localhost:8000/thread/$threadId/flike/", jsonEncode({}));
      fetchThreads(); // Refresh the threads after liking
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to like thread: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    print(request.getJsonData());
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
                  // Thread Section
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
                            "Thread",
                            style: TextStyle(
                                fontFamily: 'CrimsonPro',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFFFFF)),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Bagikan Pengalaman Anda dengan Restoran Kami Melalui Thread!",
                            style: TextStyle(
                                fontFamily: 'CrimsonPro',
                                fontSize: 14,
                                color: Color(0xFFFFFFFF)),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            maxLines: 3,
                            maxLength: 450,
                            decoration: InputDecoration(
                              hintText: "Bagikan Pendapat...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                _content = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Handle upload image
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                ),
                                child: const Text("Upload Image",
                                    style: TextStyle(
                                        fontFamily: 'CrimsonPro',
                                        color: Color(0xFFFFFFFF))),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  createThread(request);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                ),
                                child: const Text("Publikasi",
                                    style: TextStyle(
                                        fontFamily: 'CrimsonPro',
                                        color: Color(0xFFFFFFFF))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Riwayat Thread Section
                  const Text(
                    "Riwayat Thread",
                    style: TextStyle(
                      fontFamily: 'CrimsonPro',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : threads.isEmpty
                          ? const Text(
                              "No threads available.",
                              style: TextStyle(color: Colors.white),
                            )
                          : Column(
                              children: threads.map((thread) {
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
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                thread['content'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontFamily: 'CrimsonPro',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              if (request.getJsonData()['data']
                                                      ['id'] ==
                                                  thread['author_id'])
                                                Row(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Show edit dialog
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            final TextEditingController
                                                                editController =
                                                                TextEditingController(
                                                                    text: thread[
                                                                        'content']);

                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Edit Thread'),
                                                              content:
                                                                  TextField(
                                                                controller:
                                                                    editController,
                                                                maxLines: 3,
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Edit your thread',
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                ),
                                                              ),
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
                                                                  onPressed:
                                                                      () {
                                                                    // Call edit method
                                                                    editThread(
                                                                        thread[
                                                                            'id'],
                                                                        editController
                                                                            .text);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Save'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Text("Edit",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'CrimsonPro',
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    TextButton(
                                                      onPressed: () {
                                                        // Show confirmation dialog
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Delete Thread'),
                                                              content: const Text(
                                                                  'Are you sure you want to delete this thread?'),
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
                                                                  onPressed:
                                                                      () {
                                                                    // Call delete method
                                                                    deleteThread(
                                                                        thread[
                                                                            'id']);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                  child: const Text(
                                                                      'Delete'),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'CrimsonPro',
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                        if (thread.containsKey('image'))
                                          Expanded(
                                            flex: 1,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                thread['image'],
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
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
