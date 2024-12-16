import 'package:flutter/material.dart';
import 'package:uas/models/review.dart';
import 'package:uas/services/review_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class EditReviewDialog extends StatefulWidget {
  final Review initialReview;

  const EditReviewDialog({
    required this.initialReview,
    super.key,
  });

  @override
  State<EditReviewDialog> createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<EditReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _judulUlasan;
  late String _teksUlasan;
  late int _penilaian;
  late DateTime _tanggal;
  late int _totalLikes;
  late List<String> _images;
  String? _selectedRestaurantId;
  List<Map<String, dynamic>> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _judulUlasan = widget.initialReview.judulUlasan;
    _teksUlasan = widget.initialReview.teksUlasan;
    _penilaian = widget.initialReview.penilaian;
    _tanggal = widget.initialReview.tanggal;
    _totalLikes = widget.initialReview.totalLikes;
    _images = List.from(widget.initialReview.images);
    _fetchRestaurants();
  }

  // Fungsi untuk mengambil daftar restoran dari backend
  Future<void> _fetchRestaurants() async {
    final request = context.read<CookieRequest>();
    final response = await request.get("http://127.0.0.1:8000/api/restaurants/");

    if (response['status'] == 'success') {
      setState(() {
        _restaurants = List<Map<String, dynamic>>.from(response['data']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Gagal mengambil daftar restoran, silakan coba lagi."),
      ));
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Membuat objek Review yang diperbarui
      final updatedReview = Review(
        id: widget.initialReview.id,
        judulUlasan: _judulUlasan,
        teksUlasan: _teksUlasan,
        penilaian: _penilaian,
        tanggal: _tanggal,
        totalLikes: _totalLikes,
        images: _images,
      );

      // Menggunakan ReviewService untuk mengirim data ke backend
      final reviewService = ReviewService();
      try {
        Review savedReview = await reviewService.updateReview(updatedReview);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Review berhasil diperbarui!")),
        );
        Navigator.of(context).pop(savedReview);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui review: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Review"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Judul Ulasan
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: _judulUlasan,
                  decoration: InputDecoration(
                    hintText: "Judul Ulasan",
                    labelText: "Judul Ulasan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onSaved: (value) {
                    _judulUlasan = value!.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Judul ulasan tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Teks Ulasan
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: _teksUlasan,
                  decoration: InputDecoration(
                    hintText: "Teks Ulasan",
                    labelText: "Teks Ulasan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  maxLines: 4,
                  onSaved: (value) {
                    _teksUlasan = value!.trim();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Teks ulasan tidak boleh kosong!";
                    }
                    return null;
                  },
                ),
              ),
              // Penilaian (Rating)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: _penilaian.toString(),
                  decoration: InputDecoration(
                    hintText: "Penilaian (1-5)",
                    labelText: "Penilaian",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _penilaian = int.tryParse(value!) ?? 1;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Penilaian tidak boleh kosong!";
                    }
                    final parsedValue = int.tryParse(value);
                    if (parsedValue == null || parsedValue < 1 || parsedValue > 5) {
                      return "Penilaian harus antara 1 dan 5!";
                    }
                    return null;
                  },
                ),
              ),
              // Tanggal Ulasan
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: _tanggal.toIso8601String().split('T')[0],
                  decoration: InputDecoration(
                    hintText: "Tanggal (YYYY-MM-DD)",
                    labelText: "Tanggal",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  onSaved: (value) {
                    _tanggal = DateTime.tryParse(value!) ?? DateTime.now();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tanggal tidak boleh kosong!";
                    }
                    if (DateTime.tryParse(value) == null) {
                      return "Format tanggal salah!";
                    }
                    return null;
                  },
                ),
              ),
              // Total Likes
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: _totalLikes.toString(),
                  decoration: InputDecoration(
                    hintText: "Total Likes",
                    labelText: "Total Likes",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _totalLikes = int.tryParse(value!) ?? 0;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Total Likes tidak boleh kosong!";
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return "Total Likes harus berupa angka positif!";
                    }
                    return null;
                  },
                ),
              ),
              // Restaurant Dropdown
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: _restaurants.isEmpty
                    ? const CircularProgressIndicator() // Menampilkan loading indicator
                    : DropdownButtonFormField<String>(
                        value: _selectedRestaurantId,
                        decoration: InputDecoration(
                          labelText: "Restaurant",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        items: _restaurants.map((restaurant) {
                          return DropdownMenuItem<String>(
                            value: restaurant['id'].toString(),
                            child: Text(restaurant['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRestaurantId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Restaurant tidak boleh kosong!";
                          }
                          return null;
                        },
                      ),
              ),
              // Image URLs (dipisahkan dengan koma)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  initialValue: _images.join(', '),
                  decoration: InputDecoration(
                    hintText: "Image URL (dipisahkan dengan koma)",
                    labelText: "Image URLs",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onSaved: (value) {
                    _images = value!.split(',').map((e) => e.trim()).toList();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Image URL tidak boleh kosong!";
                    }
                    // Optional: Tambahkan validasi URL jika diperlukan
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Tutup dialog tanpa menyimpan
          },
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[600],
          ),
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
