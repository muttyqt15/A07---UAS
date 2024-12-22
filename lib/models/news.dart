class News {
  String pk;
  Fields fields;

  News({
    required this.pk,
    required this.fields,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "fields": fields.toJson(),
      };

  // Tambahkan metode ini
  Map<String, dynamic> toMap() {
    return {
      "pk": pk,
      "fields": fields.toMap(),
    };
  }
}

class Fields {
  String judul;
  String gambar;
  String konten;
  int like;
  String author;
  DateTime tanggal;
  DateTime tanggalPembaruan;
  bool liked;
  DataRestaurant dataRestaurant;

  Fields({
    required this.judul,
    required this.gambar,
    required this.konten,
    required this.like,
    required this.author,
    required this.tanggal,
    required this.tanggalPembaruan,
    required this.liked,
    required this.dataRestaurant,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        judul: json["judul"] ?? '',
        gambar: json["gambar"] ?? '',
        konten: json["konten"] ?? '',
        like: json["like"] ?? 0,
        author: json["author"] ?? '',
        tanggal: DateTime.parse(json["tanggal"]) ?? DateTime.now(),
        tanggalPembaruan: DateTime.parse(json["tanggal_pembaruan"]) ?? DateTime.now(),
        liked: json["liked"] ?? false,
        dataRestaurant: DataRestaurant.fromJson(json["data_restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "judul": judul,
        "gambar": gambar,
        "konten": konten,
        "like": like,
        "author": author,
        "tanggal": tanggal.toIso8601String(),
        "tanggal_pembaruan": tanggalPembaruan.toIso8601String(),
        "liked": liked,
        "data_restaurant": dataRestaurant.toJson(),
      };

  Map<String, dynamic> toMap() {
    return {
      "judul": judul,
      "gambar": gambar,
      "konten": konten,
      "like": like,
      "author": author,
      "tanggal": tanggal.toIso8601String(),
      "tanggal_pembaruan": tanggalPembaruan.toIso8601String(),
      "liked": liked,
      "data_restaurant": dataRestaurant.toMap(),
    };
  }
}

class DataRestaurant {
  int id;
  String name;
  String district;
  String address;
  String operationalHours;
  String photoUrl;

  DataRestaurant({
    required this.id,
    required this.name,
    required this.district,
    required this.address,
    required this.operationalHours,
    required this.photoUrl,
  });

  factory DataRestaurant.fromJson(Map<String, dynamic> json) => DataRestaurant(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        district: json["district"] ?? '',
        address: json["address"] ?? '',
        operationalHours: json["operational_hours"] ?? '',
        photoUrl: json["photo_url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "district": district,
        "address": address,
        "operational_hours": operationalHours,
        "photo_url": photoUrl,
      };

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "district": district,
      "address": address,
      "operational_hours": operationalHours,
      "photo_url": photoUrl,
    };
  }
}
