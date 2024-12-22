import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uas/main.dart';
import 'package:uas/models/restaurant.dart';
import 'package:uas/models/review.dart';

class RestaurantService {
  Future<List<Restaurant>> fetchRestaurants(int amount) async {
    final url =
        Uri.parse('${CONSTANTS.baseUrl}/restaurant/serialized_list/$amount');
    final response = await http.get(url);

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

class ReviewService {
  //TODO: Finish review

  Future<List<Review>> fetchReviewsForRestaurant(int restaurantId) async {
    final url = Uri.parse('${CONSTANTS.baseUrl}/serialized/$restaurantId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Parse review data
      final List<dynamic> reviewJson = data['reviews'] ?? [];
      final List<Review> reviews =
          reviewJson.map((json) => Review.fromJson(json)).toList();

      return reviews;
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
