class Review {
  final String id;
  final String customerName; // Equivalent to `display_name` in Django
  final String title; // Equivalent to `judul_ulasan`
  final String text; // Equivalent to `teks_ulasan`
  final DateTime date; // Equivalent to `tanggal`
  final int rating; // Equivalent to `penilaian`
  final int totalLikes; // Total likes for the review

  Review({
    required this.id,
    required this.customerName,
    required this.title,
    required this.text,
    required this.date,
    required this.rating,
    required this.totalLikes,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      customerName: json['display_name'] ?? 'Anonymous',
      title: json['judul_ulasan'],
      text: json['teks_ulasan'],
      date: DateTime.parse(json['tanggal']),
      rating: json['penilaian'],
      totalLikes: json['total_likes'] ?? 0,
    );
  }
}
