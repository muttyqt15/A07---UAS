import 'package:flutter/material.dart';
import 'package:uas/models/review.dart';
import 'package:uas/services/review_service.dart';
import 'package:uas/screens/review/create_form.dart';
import 'package:uas/screens/review/edit_form.dart';
import 'package:uas/widgets/footer.dart';
import 'package:uas/widgets/left_drawer.dart';
import 'package:uas/widgets/review_card.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final ReviewService _reviewService = ReviewService();
  List<Review> _reviews = [];
  bool _isLoading = true;
  String _currentSort = 'like';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      List<Review> reviews = await _reviewService.fetchReviews();
      setState(() {
        _reviews = reviews;
        _sortReviews(_currentSort);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _sortReviews(String sortBy) {
    setState(() {
      _currentSort = sortBy;
      if (sortBy == 'like') {
        _reviews.sort((a, b) => b.totalLikes.compareTo(a.totalLikes));
      } else if (sortBy == 'date') {
        _reviews.sort((a, b) => b.tanggal.compareTo(a.tanggal));
      } else if (sortBy == 'rate') {
        _reviews.sort((a, b) => b.penilaian.compareTo(a.penilaian));
      }
    });
  }

  Future<void> _deleteReview(String id, int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: const Text("Apakah Anda yakin ingin menghapus review ini?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Tidak jadi hapus
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Konfirmasi hapus
              },
              child: const Text(
                "Hapus",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirm) {
      try {
        await _reviewService.deleteReview(id);
        setState(() {
          _reviews.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review berhasil dihapus')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus review: $e')),
        );
      }
    }
  }

  Future<void> _editReview(Review review, int index) async {
    final updatedReview = await showDialog<Review>(
      context: context,
      builder: (BuildContext context) {
        return EditReviewDialog(
          initialReview: review,
        );
      },
    );

    if (updatedReview != null) {
      try {
        Review savedReview = await _reviewService.updateReview(updatedReview);
        setState(() {
          _reviews[index] = savedReview;
          _sortReviews(_currentSort);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review berhasil diperbarui')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui review: $e')),
        );
      }
    }
  }

  Future<void> _addReview() async {
    final newReview = await Navigator.push<Review>(
      context,
      MaterialPageRoute(builder: (context) => const ReviewFormPage()),
    );

    if (newReview != null) {
      try {
        Review createdReview = await _reviewService.createReview(newReview);
        setState(() {
          _reviews.add(createdReview);
          _sortReviews(_currentSort);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review berhasil ditambahkan')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan review: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Mangan Solo',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Lora",
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.brown[800],
        centerTitle: true,
        elevation: 0,
      ),
      drawer: const LeftDrawer(), // Drawer
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              _reviews.isEmpty
                                  ? const Text(
                                      "Tidak ada ulasan.",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: _reviews.length,
                                      itemBuilder: (context, index) {
                                        final review = _reviews[index];
                                        return ReviewCard(
                                          review: review,
                                          onEdit: () => _editReview(review, index),
                                          onDelete: () => _deleteReview(review.id, index),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}
