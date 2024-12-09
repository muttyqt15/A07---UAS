// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uas/models/profile.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000'; // Replace with your actual API URL

  // Fetch profile data
  Future<List<Profile>> fetchProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/profile/json')); // Adjust the endpoint as needed

    if (response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      throw Exception('Failed to load profile NIGGA');
    }
  }
}


