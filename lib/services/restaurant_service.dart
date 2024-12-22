import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uas/main.dart';
import 'package:uas/models/restaurant.dart';
import 'package:uas/models/menu.dart';
import 'package:uas/models/food.dart';
import 'package:uas/models/review.dart';

class RestaurantService {
  Future<Map<String, dynamic>> fetchRestaurantDetails(int restaurantId) async {
    try {
      final url =
          Uri.parse('${CONSTANTS.baseUrl}/restaurant/serialized/$restaurantId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Null checks and default values
        final restaurant = data['restaurant'] != null
            ? Restaurant.fromJson(
                {'pk': data['restaurant']['id'], 'fields': data['restaurant']})
            : Restaurant();

        final List<dynamic> menuJson = data['menus'] ?? [];
        final List<Menu> menus =
            menuJson.map((json) => Menu.fromJson(json)).toList();

        final List<dynamic> foodJson = data['foods'] ?? [];
        final List<Food> foods =
            foodJson.map((json) => Food.fromJson(json)).toList();

        final List<dynamic> reviewJson = data['reviews'] ?? [];
        final List<Review> reviews =
            reviewJson.map((json) => Review.fromJson(json)).toList();

        return {
          'restaurant': restaurant,
          'menus': menus,
          'foods': foods,
          'reviews': reviews,
        };
      } else {
        throw Exception('Failed to load restaurant details');
      }
    } catch (e) {
      rethrow;
    }
  }

  void likeReview(String reviewId) async {
    final url = Uri.parse('${CONSTANTS.baseUrl}/restaurant/like_review/');
    final response = await http.post(url, body: {
      'review_id': reviewId.toString(),
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to like review');
    }
  }
}

String getFullImageUrl(String imagePath) {
  if (imagePath.startsWith('http')) {
    return imagePath; // Use as-is if it's already a full URL
  } else {
    print('${CONSTANTS.baseUrl}$imagePath');
    return '${CONSTANTS.baseUrl}$imagePath';
  }
}
