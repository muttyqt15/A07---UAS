import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:uas/screens/review/create_form.dart';
import 'package:uas/widgets/left_drawer.dart';

class MainReviewPage extends StatefulWidget {
  const MainReviewPage({super.key});

  @override
  State<MainReviewPage> createState() => _MainReviewPageState();
}

class _MainReviewPageState extends State<MainReviewPage> {
  List<Map<String, dynamic>> _reviewList = [];
  String _sortBy = ''; // '', 'like', 'date', 'rate'

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    final request = context.read<CookieRequest>();
    final url = "http://127.0.0.1:8000/review/flutter/user-reviews/?sort_by=$_sortBy";

    try {
      final response = await request.get(url);
      print("Response JSON: $response"); // Debug respons JSON

      if (response['status'] == 'success' && response['data'] != null) {
        setState(() {
          _reviewList = List<Map<String, dynamic>>.from(response['data'].map((review) {
            return {
              "id": review['id'] ?? "",
              "restoran_name": review['restoran_name'] ?? "Nama Restoran",
              "judul_ulasan": review['judul_ulasan'] ?? "Judul Review",
              "teks_ulasan": review['teks_ulasan'] ?? "",
              "penilaian": review['penilaian'] ?? 0,
              "tanggal": review['tanggal'] ?? "",
              "display_name": review['display_name'] ?? "Anonim",
              "total_likes": review['total_likes'] ?? 0,
              "images": (review['images'] as List<dynamic>? ?? []).cast<String>(),
            };
          }));
          if (_reviewList.isNotEmpty) _applySorting(); // Apply sorting if data exists
        });
      } else {
        print("Error Message: ${response['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengambil data review: ${response['message']}")),
        );
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan saat mengambil data.")),
      );
    }
  }


  void _applySorting() {
    setState(() {
      if (_sortBy == 'like') {
        _reviewList.sort((a, b) => b['total_likes'].compareTo(a['total_likes']));
      } else if (_sortBy == 'date') {
        _reviewList.sort((a, b) => b['tanggal'].compareTo(a['tanggal']));
      } else if (_sortBy == 'rate') {
        _reviewList.sort((a, b) => b['penilaian'].compareTo(a['penilaian']));
      }
    });
  }

  void _changeSort(String sortOption) {
    setState(() {
      _sortBy = sortOption;
      _applySorting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateReviewFormPage(),
                    ),
                  ).then((_) => fetchReviews());
                },
                child: const Text("Tulis Review"),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSortButton("Sort by Like", "like"),
                const SizedBox(width: 8),
                _buildSortButton("Sort by Date", "date"),
                const SizedBox(width: 8),
                _buildSortButton("Sort by Rate", "rate"),
              ],
            ),
            const SizedBox(height: 16),
            _reviewList.isEmpty
                ? const Center(child: Text("Tidak ada review."))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _reviewList.length,
                    itemBuilder: (context, index) {
                      return _buildReviewCard(_reviewList[index]);
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortButton(String text, String value) {
    final isSelected = _sortBy == value;
    return ElevatedButton(
      onPressed: () => _changeSort(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blueGrey : Colors.grey[300],
      ),
      child: Text(
        text,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final restoranName = review['restoran_name'];
    final judulUlasan = review['judul_ulasan'];
    final penulis = review['display_name'];
    final penilaian = review['penilaian'];
    final comment = review['teks_ulasan'];
    final tanggal = review['tanggal'];
    final images = (review['images'] as List<String>);
    final likeCount = review['total_likes'];

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restoranName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Judul: $judulUlasan"),
            Text("Penulis: $penulis"),
            Text("Rating: $penilaian/5"),
            Text("Tanggal: $tanggal"),
            const SizedBox(height: 8),
            if (images.isNotEmpty && images.first.isNotEmpty) ...[
              const SizedBox(height: 8),
              Image.network(
                images.first,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('Gambar tidak dapat dimuat');
                },
              ),
            ],
            const SizedBox(height: 8),
            Text("Komentar: $comment"),
            Text("Likes: $likeCount"),
          ],
        ),
      ),
    );
  }
}
