import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import "dart:io";
import 'package:image_picker/image_picker.dart';
import 'package:uas/services/thread.dart';

class ThreadScreen extends StatefulWidget {
  const ThreadScreen({Key? key}) : super(key: key);

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  List<dynamic> threads = [];
  bool isLoading = true;
  bool isCreating = false;
  late ThreadService ts;

  @override
  void initState() {
    super.initState();
    print("Fetching...");
    ts = ThreadService(request: context.read<CookieRequest>());
    _fetchThreads(ts);
  }

  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchThreads(ThreadService ts) async {
    final result = await ts.fetchThreads();
    print("fetcherr");
    print(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );

    if (result['success']) {
      setState(() {
        threads = result['data']['threads'];
        print(threads);
      });
    }
    isLoading = false;
  }

  Future<void> _createThread(ThreadService ts) async {
    setState(() {
      isCreating = true;
    });
    final result =
        await ts.createThread(_contentController.text, _selectedImage);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
    if (result['success']) {
      await _fetchThreads(ts);
    }
    setState(() {
      isCreating = false;
      _selectedImage = null;
      _contentController.clear();
    });
  }

  Future<void> _deleteThread(ThreadService ts, int threadId) async {
    final result = await ts.deleteThread(threadId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
    if (result['success']) {
      await _fetchThreads(ts);
    }
  }

  Future<void> _editThread(
      ThreadService ts, int threadId, String content) async {
    final result = await ts.editThread(threadId, content);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
    if (result['success']) {
      await _fetchThreads(ts);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final request = context.watch<CookieRequest>();
    // print(request.getJsonData());

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
                            controller: _contentController,
                            maxLength: 450,
                            decoration: InputDecoration(
                              hintText: "Bagikan Pendapat...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Handle upload image
                                  _pickImage();
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
                                onPressed: () async {
                                  // createThread();
                                  _createThread(ts);
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
                                              if (ts.request
                                                          .getJsonData()['data']
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
                                                                _editController =
                                                                TextEditingController(
                                                                    text: thread[
                                                                        'content']);

                                                            return AlertDialog(
                                                              title: const Text(
                                                                  'Edit Thread'),
                                                              content:
                                                                  TextField(
                                                                controller:
                                                                    _editController,
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
                                                                      () async {
                                                                    // Call edit method
                                                                    await _editThread(
                                                                        ts,
                                                                        thread[
                                                                            'id'],
                                                                        _editController
                                                                            .text);
                                                                    // editThread(
                                                                    //     thread[
                                                                    //         'id'],
                                                                    //     _editController
                                                                    //         .text);
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
                                                                      () async {
                                                                    // Call delete method
                                                                    await _deleteThread(
                                                                        ts,
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
                                        if (thread.containsKey('image') &&
                                            thread['image'] != "")
                                          Expanded(
                                            flex: 1,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                "http://10.0.2.2:8000/media/${thread['image']}",
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
