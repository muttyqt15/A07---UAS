// // api_service.dart

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:uas/models/profile.dart';

// class ApiService {
//   static const String baseUrl = 'http://127.0.0.1:8000'; // Replace with your actual API URL

//   // Fetch profile data
//   Future<List<Profile>> fetchProfile() async {
//     final response = await http.get(Uri.parse('$baseUrl/profile/json')); // Adjust the endpoint as needed

//     if (response.statusCode == 200) {
//       return profileFromJson(response.body);
//     } else {
//       throw Exception('Failed to load profile NIGGA');
//     }
//   }
// }


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:uas/models/profile.dart';

// class ApiService {
//   static const String baseUrl = 'http://127.0.0.1:8000';

//   // Fetch profile data
//   Future<Profile> fetchProfile(request) async {
//     final url = Uri.parse('$baseUrl/profile/fetch');
//     // final headers = {'Content-Type': 'application/json'};

//     final response = await request.get(url);

    

//     if (response.statusCode == 200) {
//       // Print the raw JSON response
//       print('Raw JSON fetched: ${response.body}');
//       final data = json.decode(response.body);

//       // Print the parsed JSON data
//       print('Parsed JSON: $data');

//       if (data['success']) {
//         return Profile.fromJson(data['profile']);
//       } else {
//         throw Exception(data['message']);
//       }
//     } else {
//       print('failed to fetch');
//       throw Exception('Failed to fetch profile data');
      
//     }
//   }
// }

import 'dart:convert';
import 'package:uas/models/profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ApiService {
  Future<Profile> fetchProfile(CookieRequest request) async {
    try{
      final response = await request.get('http://localhost:8000/profile/fetch_profile/');
    // print('Response status: ${response.statusCode}');
      final data = jsonDecode(response.body);
      if (data['success']) {
        return Profile.fromJson(data['profile']);
      }else {
        throw Exception('Failed to load profile: ${data['message']}');
      }
    }catch(e){
      throw Exception('Failed to load profile');
    }


    // if (response.statusCode == 200) {
    //   final data = jsonDecode(response.body);
    //   if (data['success']) {
    //     return Profile.fromJson(data['profile']);
    //   } else {
    //     throw Exception('Failed to load profile: ${data['message']}');
    //   }
    // } else {
    //   throw Exception('Failed to load profile');
    // }
  }
}

