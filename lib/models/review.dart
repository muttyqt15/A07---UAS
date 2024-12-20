import 'dart:convert';

// Function to parse the JSON response into a list of Review objects
List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str)["data"].map((x) => Review.fromJson(x)));

// Function to convert the Review list back into JSON format
String reviewToJson(List<Review> data) =>
    json.encode({"data": List<dynamic>.from(data.map((x) => x.toJson()))});

class Review {
  final String id;
  final Fields fields;

  Review({
    required this.id,
    required this.fields,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"] ?? '',
        fields: Fields.fromJson(json),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fields": fields.toJson(),
      };
}

class Fields {
  final String restoranName;
  final String judulUlasan;
  final String teksUlasan;
  final int penilaian;
  final DateTime tanggal;
  final String displayName;
  final int totalLikes;
  final List<String> images;

  Fields({
    required this.restoranName,
    required this.judulUlasan,
    required this.teksUlasan,
    required this.penilaian,
    required this.tanggal,
    required this.displayName,
    required this.totalLikes,
    required this.images,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        restoranName: json["restoran_name"] ?? '',
        judulUlasan: json["judul_ulasan"] ?? '',
        teksUlasan: json["teks_ulasan"] ?? '',
        penilaian: json["penilaian"] ?? 0,
        tanggal: DateTime.parse(json["tanggal"] ?? DateTime.now().toString()),
        displayName: json["display_name"] ?? 'Anonymous',
        totalLikes: json["total_likes"] ?? 0,
        images: List<String>.from(json["images"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "restoran_name": restoranName,
        "judul_ulasan": judulUlasan,
        "teks_ulasan": teksUlasan,
        "penilaian": penilaian,
        "tanggal": tanggal.toIso8601String(),
        "display_name": displayName,
        "total_likes": totalLikes,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
