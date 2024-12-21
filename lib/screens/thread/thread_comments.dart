import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/main.dart';
import 'package:uas/models/thread.dart';
import 'package:uas/services/thread.dart';
import 'package:uas/widgets/left_drawer.dart';

class ThreadCommentsPage extends StatefulWidget {
  final Thread thread;

  const ThreadCommentsPage({
    super.key,
    required this.thread,
  });

  @override
  _ThreadCommentsPageState createState() => _ThreadCommentsPageState();
}

class _ThreadCommentsPageState extends State<ThreadCommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> comments = [];
  bool isLoading = true;
  bool isCreating = false;
  late ThreadService ts;
  late int commentCount;

  @override
  void initState() {
    super.initState();
    ts = ThreadService(request: context.read<CookieRequest>());
    setState(() {
      commentCount = widget.thread.commentCount;
    });
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final result = await ts.fetchDetailThread(widget.thread.id);
    if (result['success']) {
      final List<dynamic> commentsJson =
          result['data']['data']['comments'] ?? [];
      setState(() {
        comments = commentsJson.map((json) => Comment.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _createComment() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a comment')),
      );
      return;
    }

    setState(() {
      isCreating = true;
    });

    final result = await ts.addComment(
      widget.thread.id,
      _commentController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }

    if (result['success']) {
      _commentController.clear();
      await _fetchComments();
    }

    setState(() {
      isCreating = false;
      commentCount++;
    });
    Navigator.of(context).pop();
  }

  Future<void> _deleteComment(int commentId) async {
    final result = await ts.deleteComment(commentId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }

    if (result['success']) {
      await _fetchComments();
    }

    Navigator.of(context).pop();
  }

  Widget _buildOriginalThread() {
    return Card(
      color: const Color(0xFFE5D2B0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: widget.thread.authorProfilePic != null
                      ? NetworkImage(widget.thread.authorProfilePic!)
                      : null,
                  child: widget.thread.authorProfilePic == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.thread.authorName,
                      style: const TextStyle(
                        fontFamily: 'CrimsonPro',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _timeDifference(widget.thread.createdAt),
                      style: const TextStyle(
                        fontFamily: 'CrimsonPro',
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.thread.image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  "${CONSTANTS.baseUrl}/${widget.thread.image}",
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              widget.thread.content,
              style: const TextStyle(
                fontFamily: 'CrimsonPro',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${widget.thread.likeCount} likes',
                  style: const TextStyle(
                    fontFamily: 'CrimsonPro',
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$commentCount comments',
                  style: const TextStyle(
                    fontFamily: 'CrimsonPro',
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
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
                  "Add a Comment",
                  style: TextStyle(
                    fontFamily: 'CrimsonPro',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _commentController,
                  maxLines: 3,
                  maxLength: 250,
                  decoration: const InputDecoration(
                      hintText: "Write your comment...",
                      border: InputBorder.none,
                      fillColor: Color(CONSTANTS.lion),
                      filled: true,
                      focusColor: Colors.transparent),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: isCreating ? null : _createComment,
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

  Widget _buildCommentCard(Comment comment) {
    return Card(
      color: const Color(0xFFE5D2B0),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: comment.authorProfilePic != null
                      ? NetworkImage(comment.authorProfilePic!)
                      : null,
                  child: comment.authorProfilePic == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(
                        fontFamily: 'CrimsonPro',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _timeDifference(comment.createdAt),
                      style: const TextStyle(
                        fontFamily: 'CrimsonPro',
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (comment.authorId == ts.request.getJsonData()['data']['id'])
                  PopupMenuButton(
                    color: const Color(CONSTANTS
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
                            () => _showDeleteDialog(comment
                                .id), // Assuming 'comment' is defined elsewhere
                          );
                        },
                      ),
                    ],
                    icon: const Icon(
                      Icons.more_vert,
                      color: Color(CONSTANTS.licorice), // Icon color: Licorice
                    ),
                  )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              comment.content,
              style: const TextStyle(
                fontFamily: 'CrimsonPro',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(int commentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        backgroundColor:
            const Color(CONSTANTS.licorice), // Dialog background color
        title: const Text(
          'DELETE COMMENT',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(CONSTANTS.dutch), // Title color: Licorice
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this comment?',
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
            onPressed: () => _deleteComment(commentId),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(
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
      appBar: AppBar(
        title: const Text(
          'MANGAN" SOLO',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(CONSTANTS.dutch),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/batik.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildOriginalThread(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _showCommentDialog(context);
                },
                child: const Text('Add Comment'),
              ),
              const SizedBox(height: 16),
              const Text(
                "Comments",
                style: TextStyle(
                  fontFamily: 'CrimsonPro',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : comments.isEmpty
                      ? const Center(
                          child: Text(
                            'No comments yet',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'CrimsonPro',
                            ),
                          ),
                        )
                      : Column(
                          children: comments
                              .map((comment) => _buildCommentCard(comment))
                              .toList(),
                        ),
            ],
          ),
        ],
      ),
    );
  }
}
