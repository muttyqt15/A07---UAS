import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:uas/models/review.dart';
import 'package:intl/intl.dart';
import 'package:uas/screens/review/create_form.dart';

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
        _reviewList.sort((a, b) => b.fields.totalLikes.compareTo(a.fields.totalLikes));
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
      appBar: AppBar(title: const Text('Review')),
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
              // Header Card
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
                      style: TextStyle(
                        color: Colors.white, // Teks putih
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateReviewFormPage(), // Arahkan ke halaman CreateForm
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA18971), // Background cokelat
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Tulis Review",
                        style: TextStyle(
                          color: Colors.white, // Teks putih
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title
              const Text(
                "Riwayat Review",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Sorting Buttons
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF44392F),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildSortButton('like', 'Sort by Like'),
                        ),
                        const SizedBox(width: 10), // Space between buttons
                        Expanded(
                          child: _buildSortButton('date', 'Sort by Date'),
                        ),
                        const SizedBox(width: 10), // Space between buttons
                        Expanded(
                          child: _buildSortButton('rate', 'Sort by Rate'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Space between rows
                    GestureDetector(
                      onTap: () => _sortReviews('restaurant'),
                      child: Container(
                        width: double.infinity, // Full width
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _sortBy == 'restaurant'
                              ? const Color(0xFFDECDBE)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: const Color(0xFFFFFBF2),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          "Sort by Restaurant",
                          style: TextStyle(
                            color: _sortBy == 'restaurant'
                                ? const Color(0xFF5F4D40)
                                : const Color(0xFFFFFBF2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Review Cards
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
        alignment: Alignment.center, // Center text within the button
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
    final restoranName = review.fields.restoranName;
    final judulUlasan = review.fields.judulUlasan;
    final penulis = review.fields.displayName;
    final penilaian = review.fields.penilaian;
    final comment = review.fields.teksUlasan;
    final tanggal = review.fields.tanggal;
    final images = review.fields.images;
    final likeCount = review.fields.totalLikes;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        children: [
          // Linear Gradient Border
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8D7762), Color(0xFFE3D6C9)], // Stroke gradient
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          // Solid Card Content
          Container(
            margin: const EdgeInsets.all(4), // Space for stroke effect
            decoration: BoxDecoration(
              color: const Color(0xFF5F4D40), // Solid background for the card
              borderRadius: BorderRadius.circular(16), // Slightly smaller radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restoranName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Judul: $judulUlasan",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Penulis: $penulis",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Rating: $penilaian/5",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Tanggal: ${DateFormat('dd MMM yyyy').format(tanggal)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  if (images.isNotEmpty)
                    Image.network(
                      images.first,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'Gambar tidak dapat dimuat',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    "Komentar: $comment",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Likes: $likeCount",
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Edit Action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA18971), // Background cokelat
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                            color: Colors.white, // Teks putih
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: () {
                          // Delete Action
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
          ),
        ],
      ),
    );
  }

}
