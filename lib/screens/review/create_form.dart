import 'dart:io';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/services/review_service.dart';
import 'package:uas/screens/review/main_review.dart';
import 'package:uas/widgets/left_drawer.dart';
import 'package:uas/models/restaurant.dart';

class CreateReviewFormPage extends StatefulWidget {
  const CreateReviewFormPage({super.key});

  @override
  State<CreateReviewFormPage> createState() => _CreateReviewFormPageState();
}

class _CreateReviewFormPageState extends State<CreateReviewFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? _displayName; // Optional
  String _judulUlasan = ""; // Required
  int? _selectedRestaurantId; // Dropdown restaurant
  int? _rating; // Dropdown rating 1-5
  String _teksUlasan = ""; // Required
  File? _selectedImageFile; // Image file (native)
  Uint8List? _selectedImageBytes; // Image bytes (web)
  String _selectedFileName = "No File Selected"; // Default text
  List<Restaurant> _restaurants = []; // List of restaurants

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    final request = context.read<CookieRequest>();
    final reviewService = ReviewService(request: request);

    try {
      final restaurants = await reviewService.fetchAllRestaurants();
      setState(() {
        _restaurants = restaurants;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching restaurants: $e')),
      );
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Ambil instance CookieRequest
        final request = Provider.of<CookieRequest>(context, listen: false);

        // Buat instance service
        final reviewService = ReviewService(request: request);

        // (Opsional) Cek dulu apakah logged in
        if (!request.loggedIn) {
          // Jika belum login, coba login 
          // (Anda bisa skip ini kalau memang user harus login lebih dulu di tempat lain)
          final loginResp = await request.login(
            'http://localhost:8000/auth/flogin/',
            {
              'username': 'testuser',
              'password': 'testpass',
            },
          );
          if (loginResp['status'] != 'success') {
            _showSnackBar("Login gagal: ${loginResp['message']}");
            return;
          }
        }

        // Siapkan imageBytes (opsional)
        Uint8List? imageBytes;
        if (_selectedImageFile != null) {
          imageBytes = await _selectedImageFile!.readAsBytes();
        } else if (_selectedImageBytes != null) {
          imageBytes = _selectedImageBytes;
        }

        // Panggil service createReview
        final response = await reviewService.createReview(
          restaurantId: _selectedRestaurantId!,
          title: _judulUlasan,
          content: _teksUlasan,
          rating: _rating!,
          imageBytes: imageBytes,
          displayName: _displayName,
        );

        if (response['success'] == true) {
          _showSnackBar("Review berhasil dibuat!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainReviewPage()),
          );
        } else {
          _showSnackBar("Gagal membuat review: ${response['message']}");
        }
      } catch (e) {
        _showSnackBar("Error saat membuat review: $e");
      }
    }
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Review'),
        centerTitle: true,
        backgroundColor: const Color(0xFF5F4D40),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Card(
          color: const Color(0xFFE5D2B0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle("Tambah Review"),
                  const SizedBox(height: 16),
                  _buildTextField("Nama Tampilan (Opsional)", "Masukkan nama tampilan", (value) {
                    _displayName = value.isEmpty ? null : value;
                  }),
                  const SizedBox(height: 16),
                  _buildTextField("Judul Ulasan", "Masukkan judul ulasan", (value) {
                    _judulUlasan = value;
                  }, required: true),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    "Pilih Restoran",
                    _restaurants.map((e) {
                      return DropdownMenuItem<int>(
                        value: e.id,
                        child: Text(e.name),
                      );
                    }).toList(),
                    (value) {
                      if (value != null) {
                        setState(() => _selectedRestaurantId = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    "Penilaian (1-5)",
                    List.generate(5, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text("${index + 1}"),
                      );
                    }),
                    (value) {
                      if (value != null) {
                        setState(() => _rating = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField("Teks Ulasan", "Masukkan teks ulasan", (value) {
                    _teksUlasan = value;
                  }, required: true, maxLines: 4),
                  const SizedBox(height: 16),
                  _buildFilePicker(),
                  const SizedBox(height: 16),
                  if (_selectedImageBytes != null || _selectedImageFile != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Gambar yang Dipilih:"),
                        const SizedBox(height: 8),
                        _buildImagePreview(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  const SizedBox(height: 24),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5F4D40)),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged,
      {bool required = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onChanged: onChanged,
          validator: (value) {
            if (required && (value == null || value.isEmpty)) {
              return "Field ini wajib diisi";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<DropdownMenuItem<int>> items, Function(int?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          items: items,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onChanged: onChanged,
          validator: (value) => value == null ? "Field ini wajib dipilih" : null,
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: _pickFile,
          child: const Text("Pilih File"),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(_selectedFileName, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImageBytes != null) {
      return Image.memory(
        _selectedImageBytes!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if (_selectedImageFile != null) {
      return Image.file(
        _selectedImageFile!,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainReviewPage())),
          child: const Text("Kembali"),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text("Kirim"),
        ),
      ],
    );
  }
}