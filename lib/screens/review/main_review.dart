import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:uas/models/review.dart';
import 'package:intl/intl.dart';
import 'package:uas/screens/review/create_form.dart';
import 'package:uas/widgets/review/modal_edit.dart';

class MainReviewPage extends StatefulWidget {
  const MainReviewPage({super.key});

  @override
  State<MainReviewPage> createState() => _MainReviewPageState();
}

class _MainReviewPageState extends State<MainReviewPage> {
  List<Review> _reviewList = [];
  String _sortBy = 'like';

  Future<void> fetchReviews() async {
    final request = context.read<CookieRequest>();
    final url = "http://localhost:8000/review/flutter/user-reviews/";

    final response = await request.get(url);
    print("Response JSON: $response");

    if (response['status'] == 'success' && response['data'] != null) {
      setState(() {
        _reviewList = List<Review>.from(
          (response['data'] as List).map((x) => Review.fromJson(x)),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  void _sortReviews(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      if (sortBy == 'like') {
        _reviewList.sort((a, b) => b.fields.likes.length.compareTo(a.fields.likes.length));
      } else if (sortBy == 'date') {
        _reviewList.sort((a, b) => b.fields.tanggal.compareTo(a.fields.tanggal));
      } else if (sortBy == 'rate') {
        _reviewList.sort((a, b) => b.fields.penilaian.compareTo(a.fields.penilaian));
      } else if (sortBy == 'restaurant') {
        _reviewList.sort((a, b) => a.fields.restoran.toString().compareTo(b.fields.restoran.toString()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Review Anda'),
        backgroundColor: const Color(0xFF5F4D40),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/batik.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
          ),
          ListView(
            children: [
              // Header
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF5F4D40),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Review",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Bagikan Pengalaman Anda dengan Restoran Kami Melalui Ulasan!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateReviewFormPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA18971),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Tulis Review",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sort Options
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSortButton('like', 'Sort by Like'),
                    _buildSortButton('date', 'Sort by Date'),
                    _buildSortButton('rate', 'Sort by Rate'),
                    _buildSortButton('restaurant', 'Sort by Restaurant'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Review List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reviewList.length,
                itemBuilder: (context, index) {
                  return _buildReviewCard(_reviewList[index]);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortButton(String sortBy, String text) {
    final isActive = _sortBy == sortBy;
    return GestureDetector(
      onTap: () => _sortReviews(sortBy),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFDECDBE) : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(
            color: const Color(0xFFFFFBF2),
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? const Color(0xFF5F4D40) : const Color(0xFFFFFBF2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    final fields = review.fields;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF5F4D40),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Restoran ID: ${fields.restoran}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Text(
              "Judul: ${fields.judulUlasan}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Rating: ${fields.penilaian}/5",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Tanggal: ${DateFormat('dd MMM yyyy').format(fields.tanggal)}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            if (fields.images.isNotEmpty)
              Image.network(
                fields.images.first,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Text(
                  'Gambar tidak dapat dimuat',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              "Komentar: ${fields.teksUlasan}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Likes: ${fields.likes.length}",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ModalEditReview(
                          reviewId: review.pk,
                          initialJudulUlasan: fields.judulUlasan,
                          initialTeksUlasan: fields.teksUlasan,
                          initialPenilaian: fields.penilaian,
                          initialDisplayName: fields.displayName,
                          initialImages: fields.images,
                        ),
                      ),
                    );

                    if (updated == true) {
                      fetchReviews();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA18971),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    // Logic untuk menghapus ulasan
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
