import 'dart:convert';

List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str)["data"].map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) =>
    json.encode({"status": "success", "data": data.map((x) => x.toJson()).toList()});

class Review {
  final String model;
  final String pk;
  final Fields fields;

  Review({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      model: 'review',
      pk: json["id"] ?? '', // Menggunakan "id" dari JSON
      fields: Fields(
        customer: json["customer"] ?? 0,
        restoranName: json["restoran_name"] ?? 'Unknown Restaurant', // Gunakan nama restoran
        judulUlasan: json["judul_ulasan"] ?? 'No Title',
        tanggal: json["tanggal"] != null
            ? DateTime.tryParse(json["tanggal"].toString()) ?? DateTime.now()
            : DateTime.now(),
        teksUlasan: json["teks_ulasan"] ?? 'No review available',
        penilaian: json["penilaian"] ?? 0,
        waktuEditTerakhir: json["waktu_edit_terakhir"] != null
            ? DateTime.tryParse(json["waktu_edit_terakhir"].toString()) ?? DateTime.now()
            : DateTime.now(),
        displayName: json["display_name"] ?? 'Anonymous',
        likes: List<String>.from(json["likes"] ?? []),
        images: List<String>.from(json["images"] ?? []),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "model": model,
        "id": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  final int customer;
  final String restoranName; // Mengganti restoran ID dengan nama restoran
  final String judulUlasan;
  final DateTime tanggal;
  final String teksUlasan;
  final int penilaian;
  final DateTime waktuEditTerakhir;
  final String displayName;
  final List<String> likes;
  final List<String> images;

  Fields({
    this.customer = 0,
    this.restoranName = 'Unknown Restaurant',
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
      customer: json["customer"] ?? 0,
      restoranName: json["restoran_name"] ?? 'Unknown Restaurant',
      judulUlasan: json["judul_ulasan"] ?? 'No Title',
      tanggal: json["tanggal"] != null
          ? DateTime.tryParse(json["tanggal"].toString()) ?? DateTime.now()
          : DateTime.now(),
      teksUlasan: json["teks_ulasan"] ?? 'No review available',
      penilaian: json["penilaian"] ?? 0,
      waktuEditTerakhir: json["waktu_edit_terakhir"] != null
          ? DateTime.tryParse(json["waktu_edit_terakhir"].toString()) ?? DateTime.now()
          : DateTime.now(),
      displayName: json["display_name"] ?? 'Anonymous',
      likes: List<String>.from(json["likes"] ?? []),
      images: List<String>.from(json["images"] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        "customer": customer,
        "restoran_name": restoranName, // Output nama restoran ke JSON
        "judul_ulasan": judulUlasan,
        "tanggal": tanggal.toIso8601String(),
        "teks_ulasan": teksUlasan,
        "penilaian": penilaian,
        "waktu_edit_terakhir": waktuEditTerakhir.toIso8601String(),
        "display_name": displayName,
        "likes": likes,
        "images": images,
      };
}