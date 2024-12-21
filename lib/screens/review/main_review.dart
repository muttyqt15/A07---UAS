import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:intl/intl.dart';
import 'package:uas/models/review.dart';
import 'package:uas/screens/review/create_form.dart';
import 'package:uas/services/review_service.dart';
import 'package:uas/widgets/review/modal_edit.dart';

class MainReviewPage extends StatefulWidget {
  const MainReviewPage({super.key});

  @override
  State<MainReviewPage> createState() => _MainReviewPageState();
}

class _MainReviewPageState extends State<MainReviewPage> {
  late final ReviewService _reviewService;
  List<Review> _reviewList = [];
  bool isLoading = true;
  String _sortBy = 'like';

  @override
  void initState() {
    super.initState();
    // Menginisialisasi _reviewService di initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      _reviewService = ReviewService(request: request);
      fetchReviews(); // Memanggil fetchReviews setelah _reviewService diinisialisasi
    });
  }

  Future<void> fetchReviews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final request = context.read<CookieRequest>();
      final response = await request.get('http://localhost:8000/review/flutter/user-reviews/');
      setState(() {
        _reviewList = (response['data'] as List)
            .map((data) => Review.fromJson(data))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching reviews: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteReview(String reviewId) async {
    try {
      final response = await _reviewService.request.post(
        'http://localhost:8000/review/flutter/delete/$reviewId/',
        jsonEncode({}),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review deleted successfully')),
        );
        fetchReviews(); // Refresh reviews after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete review: $e')),
      );
    }
  }

  void sortReviews(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      if (sortBy == 'like') {
        _reviewList.sort((a, b) => b.fields.likes.length.compareTo(a.fields.likes.length));
      } else if (sortBy == 'date') {
        _reviewList.sort((a, b) => b.fields.tanggal.compareTo(a.fields.tanggal));
      } else if (sortBy == 'rate') {
        _reviewList.sort((a, b) => b.fields.penilaian.compareTo(a.fields.penilaian));
      } else if (sortBy == 'restaurant') {
        _reviewList.sort((a, b) => a.fields.restoranName.compareTo(b.fields.restoranName));
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
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    _buildHeader(),
                    _buildSortOptions(),
                    _buildReviewList(),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
    );
  }

  Widget _buildSortOptions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5F4D40),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildSortButton('like', 'Sort by Like'),
          _buildSortButton('date', 'Sort by Date'),
          _buildSortButton('rate', 'Sort by Rate'),
          _buildSortButton('restaurant', 'Sort by Restaurant'),
        ],
      ),
    );
  }

  Widget _buildSortButton(String sortBy, String text) {
    final isActive = _sortBy == sortBy;
    return GestureDetector(
      onTap: () => sortReviews(sortBy),
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

  Widget _buildReviewList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reviewList.length,
      itemBuilder: (context, index) {
        return _buildReviewCard(_reviewList[index]);
      },
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
              "Restoran: ${fields.restoranName}",
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
                    final updated = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ModalEditReview(
                          reviewId: review.pk,
                          initialJudulUlasan: fields.judulUlasan,
                          initialTeksUlasan: fields.teksUlasan,
                          initialPenilaian: fields.penilaian,
                          initialDisplayName: fields.displayName,
                          initialImages: fields.images,
                        );
                      },
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
                  onPressed: () => deleteReview(review.pk),
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
