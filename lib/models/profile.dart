// // To parse this JSON data, do
// //
// //     final profile = profileFromJson(jsonString);

// import 'dart:convert';

// List<Profile> profileFromJson(String str) => List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

// String profileToJson(List<Profile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Profile {
//     String model;
//     int pk;
//     Fields fields;

//     Profile({
//         required this.model,
//         required this.pk,
//         required this.fields,
//     });

//     factory Profile.fromJson(Map<String, dynamic> json) => Profile(
//         model: json["model"],
//         pk: json["pk"],
//         fields: Fields.fromJson(json["fields"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "model": model,
//         "pk": pk,
//         "fields": fields.toJson(),
//     };
// }

// class Fields {
//     int user;
//     String bio;
//     String profilePic;

//     Fields({
//         required this.user,
//         required this.bio,
//         required this.profilePic,
//     });

//     factory Fields.fromJson(Map<String, dynamic> json) => Fields(
//         user: json["user"],
//         bio: json["bio"],
//         profilePic: json["profile_pic"],
//     );

//     Map<String, dynamic> toJson() => {
//         "user": user,
//         "bio": bio,
//         "profile_pic": profilePic,
//     };
// }

class Profile {
  final String role;
  final String username;
  final String email;
  final String bio;
  final String? profilePic;

  Profile({
    required this.role,
    required this.username,
    required this.email,
    required this.bio,
    this.profilePic,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      role: json['role'],
      username: json['username'],
      email: json['email'],
      bio: json['bio'],
      profilePic: json['profile_pic'],
    );
  }
}

