import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uas/models/restaurant.dart';
import 'package:uas/models/menu.dart';
import 'package:uas/models/food.dart';
import 'package:uas/models/review.dart';

class RestaurantService {
  static const String baseUrl =
      'http://localhost:8000'; // Update to your server URL

  Future<Map<String, dynamic>> fetchRestaurantDetails(int restaurantId) async {
    final url = Uri.parse('$baseUrl/restaurant/serialized/$restaurantId');
    final response = await http.get(url);
    

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Parse restaurant data
      final restaurant = Restaurant.fromJson(data['restaurant']);

      // Parse menu data
      final List<dynamic> menuJson = data['menus'] ?? [];
      final List<Menu> menus =
          menuJson.map((json) => Menu.fromJson(json)).toList();

      // Parse food data
      final List<dynamic> foodJson = data['foods'] ?? [];
      final List<Food> foods =
          foodJson.map((json) => Food.fromJson(json)).toList();

      // Parse review data
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
  }
}
