import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Welcome Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.brown, // Temporary background color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selamat Datang di Mangan' Solo",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  "Makanan Lezat Menanti Anda!",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Pelajari Lebih Lanjut"),
                ),
              ],
            ),
          ),

          // Info Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Tahukah Anda?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Solo memiliki beragam kuliner khas yang lezat dan ramah di kantong! Dari Nasi Liwet hingga camilan tradisional...",
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Popular Restaurants Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Restoran Populer",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                for (var i = 0; i < 3; i++) // Loop to create restaurant cards
                  RestaurantCard(),
              ],
            ),
          ),

          // Featured Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center the content
              children: [
                Text(
                  "Pilihan Teratas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                FeaturedRestaurant(),
                SizedBox(height: 16),
                Text(
                  "Apa Kata Mereka Tentang Restoran \"Mbak Lies\"?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ReviewCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Temporary asset using a placeholder container
            Container(
              width: 80,
              height: 80,
              color: Colors.grey[300], // Placeholder background color
              child: Icon(Icons.image,
                  size: 40, color: Colors.grey), // Placeholder icon
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nama Restoran",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Jam Operasional: 08:00 - 21:00"),
                  Text("Alamat: Jl. Napoleon ABCD EFGH"),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Lihat Rincian"),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedRestaurant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            height: 150,
            color: Colors.grey[300], // Placeholder background color
            child: Icon(Icons.image,
                size: 80, color: Colors.grey), // Placeholder icon
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Warung Selat \"Mbak Lies\"",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              child: Text("Lihat Rincian"),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Judul Review",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ac massa vehicula.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              "DELYA",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
