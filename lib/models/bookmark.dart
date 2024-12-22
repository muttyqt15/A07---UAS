class Bookmark {
  final int id;
  final String name;
  final String address;
  final bool isFavorited;

  Bookmark({
    required this.id,
    required this.name,
    required this.address,
    this.isFavorited = true,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      isFavorited: json['is_favorited'] ?? true,
    );
  }
}