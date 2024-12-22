

class Thread {
  final int id;
  final String content;
  final String authorName;
  final int authorId;
  final String? authorProfilePic;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int commentCount;
  final int likeCount;
  final String? image;
  final bool? liked;

  Thread({
    required this.id,
    required this.content,
    required this.authorName,
    required this.authorId,
    this.authorProfilePic,
    required this.createdAt,
    required this.commentCount,
    required this.likeCount,
    this.liked,
    required this.updatedAt,
    this.image,
  });

  factory Thread.fromJson(Map<String, dynamic> json) {
    return Thread(
      id: json['id'] as int,
      content: json['content'] as String,
      authorId: json['author_id'] as int,
      commentCount: json['comment_count'] ?? 0,
      likeCount: json['likes_count'] ?? 0,
      liked: json['liked'] ?? false,
      authorName: json['author_name'] as String,
      authorProfilePic: json['author_profile_pic'] as String?,
      image: json['image'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'author_id': authorId,
        'author_name': authorName,
        'author_profile_pic': authorProfilePic,
        'image': image,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'comment_count': commentCount,
        'likes_count': likeCount,
        'liked': liked,
      };

  @override
  String toString() {
    return 'Thread(id: $id, content: $content, authorName: $authorName, authorId: $authorId, '
        'authorProfilePic: $authorProfilePic, createdAt: $createdAt, '
        'updatedAt: $updatedAt, image: $image, commentCount: $commentCount, likeCount: $likeCount, liked: $liked)';
  }
}

class ThreadResponse {
  final bool success;
  final String message;
  final List<Thread> threads;

  ThreadResponse({
    required this.success,
    required this.message,
    required this.threads,
  });

  factory ThreadResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final threadsList = data['threads'] as List;

    return ThreadResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      threads: threadsList
          .map((thread) => Thread.fromJson(thread as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Comment {
  final int id;
  final String content;
  final String authorName;
  final int authorId;
  final String? authorProfilePic;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likeCount;
  final bool? liked;

  Comment({
    required this.id,
    required this.content,
    required this.authorName,
    required this.authorId,
    this.authorProfilePic,
    required this.createdAt,
    required this.updatedAt,
    required this.likeCount,
    this.liked,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      content: json['content'] as String,
      authorId: json['author_id'] as int,
      likeCount: json['like_count'] ?? 0,
      liked: json['liked'] ?? false,
      authorName: json['author_name'] as String,
      authorProfilePic: json['author_profile_pic'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'author_id': authorId,
        'author_name': authorName,
        'author_profile_pic': authorProfilePic,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'like_count': likeCount,
        'liked': liked,
      };

  @override
  String toString() {
    return 'Comment(id: $id, content: $content, authorName: $authorName, authorId: $authorId, '
        'authorProfilePic: $authorProfilePic, createdAt: $createdAt, '
        'updatedAt: $updatedAt, likeCount: $likeCount, liked: $liked)';
  }
}

class CommentResponse {
  final bool success;
  final String message;
  final List<Comment> comments;

  CommentResponse({
    required this.success,
    required this.message,
    required this.comments,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final commentsList = data['comments'] as List;

    return CommentResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      comments: commentsList
          .map((comment) => Comment.fromJson(comment as Map<String, dynamic>))
          .toList(),
    );
  }
}

