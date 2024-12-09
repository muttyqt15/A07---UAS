// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    String id;
    String judulUlasan;
    String teksUlasan;
    int penilaian;
    DateTime tanggal;
    int totalLikes;
    List<String> images;

    Review({
        required this.id,
        required this.judulUlasan,
        required this.teksUlasan,
        required this.penilaian,
        required this.tanggal,
        required this.totalLikes,
        required this.images,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        judulUlasan: json["judul_ulasan"],
        teksUlasan: json["teks_ulasan"],
        penilaian: json["penilaian"],
        tanggal: DateTime.parse(json["tanggal"]),
        totalLikes: json["total_likes"],
        images: List<String>.from(json["images"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "judul_ulasan": judulUlasan,
        "teks_ulasan": teksUlasan,
        "penilaian": penilaian,
        "tanggal": "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
        "total_likes": totalLikes,
        "images": List<dynamic>.from(images.map((x) => x)),
    };
}
