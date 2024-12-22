import 'package:flutter/material.dart';
import 'package:uas/models/restaurant.dart';
import 'package:uas/screens/restaurant/restaurant.dart';
import 'package:uas/services/restaurant_service.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantCard({super.key, required this.restaurant});
  @override
  Widget build(BuildContext context) {
    print(restaurant.photoUrl);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
        side:
            const BorderSide(color: Colors.white70, width: 2.5), // Extra border
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4, // Shadow effect
      color: Colors.brown.withOpacity(0.8), // Card background color

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display restaurant photo
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ), // Rounded corners for the image

            child: Image.network(
              restaurant.photoUrl.isNotEmpty
                  ? getFullImageUrl(restaurant.photoUrl)
                  : 'https://via.placeholder.com/150', // Fallback image
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant name
                Text(
                  restaurant.name,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Operational hours
                Text(
                  "Jam Operasional: ${restaurant.operationalHours}",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 8),
                // Address
                Text(
                  "Alamat: ${restaurant.address}",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 16),
                // Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFD6C2A3), // Button background color
                      foregroundColor: Colors.black, // Button text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      // Navigate to the RestaurantDetailScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RestaurantDetailScreen(restaurant: restaurant),
                        ),
                      );
                    },
                    child: const Text(
                      'Lihat Rincian',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
