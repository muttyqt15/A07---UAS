import "dart:io";

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/main.dart';
import 'package:uas/models/thread.dart';
import 'package:uas/screens/thread/thread_comments.dart';
import 'package:uas/services/thread.dart';

class ThreadScreen extends StatefulWidget {
  const ThreadScreen({super.key});

  @override
  _ThreadScreenState createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  @override
  void initState() {
    super.initState();
    ts = ThreadService(request: context.read<CookieRequest>());
    print("Fetching...");
    _fetchThreads(ts);
  }

  final TextEditingController _contentController = TextEditingController();
  List<Thread> threads = [];
  bool isLoading = true;
  bool isCreating = false;
  File? _selectedImage;
  late ThreadService ts;

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
    final List<dynamic> stringifiedJsonThreads =
        result['data']['threads'] ?? [];
    if (result['success']) {
      setState(() {
        threads = stringifiedJsonThreads
            .map((json) => Thread.fromJson(json))
            .toList();
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
    Navigator.of(context).pop();
  }

  Future<void> _editThread(
      ThreadService ts, int threadId, String content) async {
    final result = await ts.editThread(threadId, content);

    // Check if context is still valid before showing the SnackBar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }

    if (result['success']) {
      await _fetchThreads(ts);
    }

    // Check if context is still valid before popping the navigator
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildThreads() {
    return Column(
      children: [
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
                    style: TextStyle(color: Colors.black),
                  )
                : Column(
                    children: threads.map((thread) {
                      return _buildThreadCard(thread);
                    }).toList(),
                  ),
      ],
    );
  }

  Widget _buildPostCard() {
    return Card(
        color: const Color(0xFF5F4D40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildThreadCreate(
            _contentController, _pickImage, () => _createThread(ts)));
  }

  Widget _buildThreadCard(Thread td) {
    return Card(
        color: const Color(0xFFE5D2B0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                          td.authorId == ts.request.getJsonData()['data']['id']
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: td.authorProfilePic != null
                                  ? NetworkImage(td.authorProfilePic!)
                                  : null, // Only use the profile picture if it's not null
                              child: td.authorProfilePic == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 40,
                                    ) // Fallback to an icon if the profile picture is null
                                  : null,
                            ),
                            const SizedBox(
                                width:
                                    8), // Space between profile picture and text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  td.authorName,
                                  style: const TextStyle(
                                    fontFamily: 'CrimsonPro',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                  ),
                                ),
                                // Calculate the time difference between createdAt and now
                                Text(
                                  _timeDifference(td.createdAt),
                                  style: const TextStyle(
                                    fontFamily: 'CrimsonPro',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (td.authorId ==
                            ts.request.getJsonData()['data']['id'])
                          PopupMenuButton(
                            color: Color(CONSTANTS
                                .licorice), // Background color for the PopupMenuButton
                            onSelected: (value) {},
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value:
                                    'delete', // You can add a value if needed for selection
                                child: const Text(
                                  'DELETE',
                                  style: TextStyle(
                                    color: Color(CONSTANTS
                                        .dutch), // Text color for menu item: Dutch
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onTap: () {
                                  // Show delete confirmation
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => _showDeleteDialog(td
                                        .id), // Assuming 'comment' is defined elsewhere
                                  );
                                },
                              ),
                              PopupMenuItem(
                                  value:
                                      'edit', // You can add a value if needed for selection
                                  child: Text(
                                    'EDIT',
                                    style: TextStyle(
                                      color: Color(CONSTANTS
                                          .dutch), // Text color for menu item: Dutch
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  onTap: () {
                                    // Show edit confirmation dialog
                                    Future.delayed(
                                      const Duration(seconds: 0),
                                      () {
                                        // Create a TextEditingController instance and pass it to the dialog
                                        TextEditingController
                                            commentController =
                                            TextEditingController(
                                                text: td.content);
                                        _showEditDialog(
                                            td.id, commentController);
                                      },
                                    );
                                  }),
                            ],
                            icon: Icon(
                              Icons.more_vert,
                              color: Color(
                                  CONSTANTS.licorice), // Icon color: Licorice
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (td.image != null)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // Use the constraints to determine the max size for the image
                          double maxSize = constraints
                              .maxWidth; // Max (full) width of the parent

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width:
                                  maxSize, // Set width based on the available width
                              height: maxSize *
                                  0.5, // Set height based on the 50% of available width
                              child: Image.network(
                                "${CONSTANTS.baseUrl}/${td.image}",
                                fit: BoxFit
                                    .cover, // Ensure the image covers the box while maintaining aspect ratio
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error,
                                      size: 40); // Fallback in case of error
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 4),
                    Text(
                      td.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'CrimsonPro',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                // Lead to comment page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ThreadCommentsPage(thread: td)),
                                );
                              },
                              icon: const Icon(Icons.chat_bubble, size: 16),
                            ),
                            Text(
                              td.commentCount.toString(),
                              style: const TextStyle(
                                fontFamily: 'CrimsonPro',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                // Liking thread
                                final result = await ts.likeThread(td.id);

                                if (result['success']) {
                                  // Handle the successful update, e.g., show a success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Liked!')),
                                  );
                                  await _fetchThreads(ts);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to update like status')),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                size: 16,
                                color: td.liked == true
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                            Text(
                              td.likeCount.toString(),
                              style: const TextStyle(
                                fontFamily: 'CrimsonPro',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildThreadCreate(TextEditingController cctr,
      VoidCallback onImagePick, VoidCallback onPublish) {
    return Padding(
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
                fontSize: 16,
                color: Color(0xFFFFFFFF)),
          ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: 3,
            controller: cctr,
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
                  onImagePick();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                child: const Text("Upload Image",
                    style: TextStyle(
                        fontFamily: 'CrimsonPro', color: Color(0xFFFFFFFF))),
              ),
              ElevatedButton(
                onPressed: () async {
                  onPublish();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                ),
                child: const Text("Publikasi",
                    style: TextStyle(
                        fontFamily: 'CrimsonPro', color: Color(0xFFFFFFFF))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(int threadId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        backgroundColor: Color(CONSTANTS.licorice), // Dialog background color
        title: const Text(
          'DELETE THREAD',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(CONSTANTS.dutch), // Title color: Licorice
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this thraed?',
          style: TextStyle(
            fontSize: 16,
            color: Color(CONSTANTS.dutch), // Content color: Dutch
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                color:
                    Color(CONSTANTS.dutch), // Cancel button text color: Coyote
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _deleteThread(ts, threadId),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(
                  CONSTANTS.dutch), // Delete button background color: Licorice
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 20), // Button padding
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Rounded corners for button
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(CONSTANTS.licorice), // Dialog background color
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int threadId, TextEditingController ctrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(CONSTANTS.lion),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edit Thread",
                  style: TextStyle(
                    fontFamily: 'CrimsonPro',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: ctrl,
                  maxLines: 3,
                  maxLength: 250,
                  decoration: InputDecoration(
                      hintText: "What's changing?",
                      border: InputBorder.none,
                      fillColor: const Color(CONSTANTS.lion),
                      filled: true,
                      focusColor: Colors.transparent),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: isCreating
                          ? null
                          : () {
                              _editThread(ts, threadId, ctrl.text);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(CONSTANTS.dutch),
                      ),
                      child: isCreating
                          ? const CircularProgressIndicator()
                          : const Text("Post Comment",
                              style: TextStyle(
                                color: const Color(CONSTANTS.licorice),
                              )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Helper function to calculate the time difference in a readable format
  String _timeDifference(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildPostCard(),
                  const SizedBox(height: 20),
                  _buildThreads(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
