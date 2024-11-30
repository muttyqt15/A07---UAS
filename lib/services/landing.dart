import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uas/models/restaurant.dart';
import 'package:uas/models/review.dart';

class RestaurantService {
  static const String baseUrl =
      'http://localhost:8000'; // Update to your server address

  Future<List<Restaurant>> fetchRestaurants(int amount) async {
    final url = Uri.parse('$baseUrl/restaurant/serialized/$amount');
    final response = await http.get(url);

    // Debug print
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    // End debug print

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Map each item in the response to a Restaurant object
      return data.map((json) {
        final fields = json['fields']; // Extract "fields" from the JSON
        return Restaurant(
          id: json['pk'], // Use "pk" as the id
          name: fields['name'] ?? 'Unknown', // Default to 'Unknown' if null
          district:
              fields['district'] ?? 'Unknown', // Default to 'Unknown' if null
          address:
              fields['address'] ?? 'Unknown', // Default to 'Unknown' if null
          operationalHours: fields['operational_hours'] ??
              'Unknown', // Default to 'Unknown' if null
          photoUrl:
              fields['photo_url'] ?? '', // Default to empty string if null
        );
      }).toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }
}

class ReviewService { //TODO: Finish review
  static const String baseUrl =
      'http://localhost:8000'; // Update to your server address

  Future<List<Review>> fetchReviewsForRestaurant(int restaurantId) async {
    final url = Uri.parse('$baseUrl/reviews/?restaurant_id=$restaurantId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
