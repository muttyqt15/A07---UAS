import 'dart:convert';

List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
  String model;
  String pk;
  Fields fields;

  Review({
    this.model = '',
    this.pk = '',
    required this.fields,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      model: 'review',
      pk: json["id"] ?? '', // Use "id" instead of "pk"
      fields: Fields(
        customer: 0,
        restoran: 0,
        judulUlasan: json["judul_ulasan"] ?? '',
        tanggal: json["tanggal"] != null
            ? DateTime.tryParse(json["tanggal"].toString())
            : DateTime.now(),
        teksUlasan: json["teks_ulasan"] ?? '',
        penilaian: json["penilaian"] ?? 0,
        waktuEditTerakhir: DateTime.now(), // Default to current time
        displayName: json["display_name"] ?? '',
        likes: [], // Default empty list
        images: List<String>.from(json["images"] ?? []),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  final int customer;
  final int restoran;
  final String judulUlasan;
  final DateTime tanggal;
  final String teksUlasan;
  final int penilaian;
  final DateTime waktuEditTerakhir;
  final String displayName;
  final List<int> likes;
  final List<String> images;

  Fields({
    this.customer = 0,
    this.restoran = 0,
    this.judulUlasan = 'No Title',
    DateTime? tanggal,
    this.teksUlasan = 'No review available',
    this.penilaian = 0,
    DateTime? waktuEditTerakhir,
    this.displayName = 'Anonymous',
    this.likes = const [],
    this.images = const [],
  })  : tanggal = tanggal ?? DateTime.now(),
        waktuEditTerakhir = waktuEditTerakhir ?? DateTime.now();

  factory Fields.fromJson(Map<String, dynamic> json) {
    return Fields(
      customer: json['customer'] ?? 0,
      restoran: json['restoran'] ?? 0,
      judulUlasan: json['judul_ulasan'] ?? 'No Title',
      tanggal:
          json['tanggal'] != null ? DateTime.tryParse(json['tanggal']) : null,
      teksUlasan: json['teks_ulasan'] ?? 'No review available',
      penilaian: json['penilaian'] ?? 0,
      waktuEditTerakhir: json['waktu_edit_terakhir'] != null
          ? DateTime.tryParse(json['waktu_edit_terakhir'])
          : null,
      displayName: json['display_name'] ?? 'Anonymous',
      likes: json['likes'] != null ? List<int>.from(json['likes']) : [],
      images:
          json['images'] != null ? List<String>.from(json['images'] ?? []) : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'customer': customer,
        'restoran': restoran,
        'judul_ulasan': judulUlasan,
        'tanggal': tanggal.toIso8601String(),
        'teks_ulasan': teksUlasan,
        'penilaian': penilaian,
        'waktu_edit_terakhir': waktuEditTerakhir.toIso8601String(),
        'display_name': displayName,
        'likes': List<dynamic>.from(likes.map((x) => x)),
        'images': List<dynamic>.from(images.map((x) => x)),
      };
}
