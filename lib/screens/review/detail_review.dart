import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/models/review.dart';
import 'package:uas/widgets/left_drawer.dart';

class DetailReviewPage extends StatefulWidget {
  const DetailReviewPage({super.key});

  @override
  State<DetailReviewPage> createState() => _DetailReviewPageState();
}

class _DetailReviewPageState extends State<DetailReviewPage> {
  Future<List<Review>> fetchReview(CookieRequest request) async {
    // Ganti URL sesuai dengan backend Django Anda
    final response = await request.get('http://127.0.0.1:8000/json/');

    if (response != null) {
      // Melakukan decode response menjadi bentuk JSON
      var data = response;

      // Melakukan konversi data JSON menjadi list Review
      List<Review> listReview = [];
      for (var d in data) {
        if (d != null) {
          listReview.add(Review.fromJson(d));
        }
      }
      return listReview;
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Review'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<Review>>(
        future: fetchReview(request),
        builder: (context, AsyncSnapshot<List<Review>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews found.'));
          } else {
            List<Review> reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(
                  title: Text(review.judulUlasan),
                  subtitle: Text(review.teksUlasan),
                  onTap: () {
                    // Navigate to detail review page or show review details
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(review.judulUlasan),
                          content: Column(
                            children: [
                              Text("Rating: ${review.penilaian}"),
                              Text("Date: ${review.tanggal.toLocal()}"),
                              Text("Likes: ${review.totalLikes}"),
                              Text("Comment: ${review.teksUlasan}"),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
