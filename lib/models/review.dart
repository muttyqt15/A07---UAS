class Review {
  final String id;
  final String customerName; // Equivalent to `display_name` in Django
  final String title; // Equivalent to `judul_ulasan`
  final String text; // Equivalent to `teks_ulasan`
  final DateTime date; // Equivalent to `tanggal`
  final int rating; // Equivalent to `penilaian`
  final int totalLikes; // Total likes for the review
  final List<String> images; // List of image URLs associated with the review

  Review({
    required this.id,
    required this.customerName,
    required this.title,
    required this.text,
    required this.date,
    required this.rating,
    required this.totalLikes,
    required this.images,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 'unknown', // Default value for `id`
      customerName: json['display_name'] ??
          'Anonymous', // Default value for `display_name`
      title: json['judul_ulasan'] ??
          'No title', // Default value for `judul_ulasan`
      text: json['teks_ulasan'] ??
          'No review text available', // Default value for `teks_ulasan`
      date: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'])
          : DateTime.now(), // Fallback to current date if null
      rating: json['penilaian'] ?? 0, // Default value for `penilaian`
      totalLikes: json['total_likes'] ?? 0, // Default value for `total_likes`
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [], // Default to empty list if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': customerName,
      'judul_ulasan': title,
      'teks_ulasan': text,
      'tanggal': date.toIso8601String(),
      'penilaian': rating,
      'total_likes': totalLikes,
      'images': images,
    };
  }
}
