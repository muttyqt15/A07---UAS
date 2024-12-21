import 'package:flutter/material.dart';
import 'package:uas/models/restaurant.dart';
import 'package:uas/models/review.dart';
import 'package:uas/services/landing.dart';
import 'restaurant_card.dart';
import 'other_cards.dart';
import 'package:uas/screens/restaurant/add_restaurant.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LandingPageScreen extends StatefulWidget {
  @override
  _LandingPageScreenState createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  late Future<List<Restaurant>> _restaurants;

  @override
  void initState() {
    super.initState();
    // Fetch restaurants using the service
    _restaurants = RestaurantService().fetchRestaurants(11);
    final request = context.read<CookieRequest>();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: Colors.brown[800],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Card
          WelcomeCard(),
          const SizedBox(height: 16),

          // 'Tahukah Anda?' Section
          TahukahAndaCard(),
          const SizedBox(height: 16),

          if (request.loggedIn && request.getJsonData()['data']['role'] == 'RESTO_OWNER')
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRestaurantPage()),
                );
              },
              child: const Text('Buat Restoran Baru'),
            ),

          // 'Restoran Populer' Section
          const Text(
            'Restoran Populer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // FutureBuilder for Restaurants
          FutureBuilder<List<Restaurant>>(
            future: _restaurants,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No restaurants available'));
              } else {
                final restaurants = snapshot.data!;
                return ListView.builder(
                  shrinkWrap:
                      true, // Allow embedding inside a scrollable ListView
                  physics:
                      const NeverScrollableScrollPhysics(), // Prevent independent scrolling
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    return RestaurantCard(restaurant: restaurants[index]);
                  },
                );
              }
            },
          ),

          // 'Pilihan Teratas' Section
          const SizedBox(height: 16),
          const Text(
            'Pilihan Teratas',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // FutureBuilder for Top Restaurants with Reviews
          // TODO: Fix the FutureBuilder to fetch reviews for the top restaurant
          FutureBuilder<List<Restaurant>>(
            future: RestaurantService()
                .fetchRestaurants(1), // Fetch one top restaurant
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('No top restaurants available'));
              } else {
                final restaurant =
                    snapshot.data!.first; // Get the top restaurant

                // Fetch reviews for the top restaurant
                return FutureBuilder<List<Review>>(
                  future:
                      ReviewService().fetchReviewsForRestaurant(restaurant.id),
                  builder: (context, reviewSnapshot) {
                    if (reviewSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (reviewSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${reviewSnapshot.error}'));
                    } else if (!reviewSnapshot.hasData ||
                        reviewSnapshot.data!.isEmpty) {
                      return const Center(
                          child:
                              Text('No reviews available for this restaurant'));
                    } else {
                      final review =
                          reviewSnapshot.data!.first; // Get the first review
                      return RestaurantReviewCard(
                        restaurant: restaurant,
                        review: review,
                      );
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
