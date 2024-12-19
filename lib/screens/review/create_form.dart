import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uas/screens/review/main_review.dart';
import 'package:uas/widgets/left_drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CreateReviewFormPage extends StatefulWidget {
  const CreateReviewFormPage({super.key});

  @override
  State<CreateReviewFormPage> createState() => _CreateReviewFormPageState();
}

class _CreateReviewFormPageState extends State<CreateReviewFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? _displayName; // Optional
  String _judulUlasan = ""; // Required
  String? _selectedRestaurantId; // Dropdown restaurant
  int? _rating; // Dropdown rating 1-5
  String _teksUlasan = ""; // Required
  File? _selectedImageFile; // Image file
  String _selectedFileName = "No File Selected"; // Default text
  List<Map<String, dynamic>> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    try {
      final response = await http.get(Uri.parse("http://127.0.0.1:8000/api/restaurants/"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _restaurants = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        _showSnackBar("Gagal mengambil data restoran.");
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImageFile = File(result.files.single.path!);
        _selectedFileName = result.files.single.name;
      });
    } else {
      _showSnackBar("Gagal memilih file.");
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        var uri = Uri.parse("http://127.0.0.1:8000/review/flutter/create/");
        var request = http.MultipartRequest('POST', uri);

        // Add form fields
        request.fields['display_name'] = _displayName ?? '';
        request.fields['restoran_id'] = _selectedRestaurantId!;
        request.fields['judul_ulasan'] = _judulUlasan;
        request.fields['teks_ulasan'] = _teksUlasan;
        request.fields['penilaian'] = _rating.toString();

        // Add image file
        if (_selectedImageFile != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'images',
            _selectedImageFile!.path,
            contentType: MediaType('image', 'jpeg'),
          ));
        }

        // Send request
        var response = await request.send();
        var responseBody = await http.Response.fromStream(response);

        if (response.statusCode == 201) {
          _showSnackBar("Review berhasil disimpan!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainReviewPage()),
          );
        } else {
          final data = jsonDecode(responseBody.body);
          _showSnackBar(data['message'] ?? "Gagal menyimpan data.");
        }
      } catch (e) {
        _showSnackBar("Error: $e");
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF8D7762), Color(0xFFE3D6C9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: const Color(0xFFE5D2B0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle("Tambah Review"),
                    const SizedBox(height: 16),
                    _buildTextField("Display Name (Optional)", "Masukkan nama tampil", (value) {
                      _displayName = value.isEmpty ? null : value;
                    }),
                    const SizedBox(height: 16),
                    _buildTextField("Judul Ulasan", "Masukkan judul ulasan", (value) {
                      _judulUlasan = value;
                    }, required: true),
                    const SizedBox(height: 16),
                    _buildDropdown("Pilih Restoran", _restaurants.map((e) {
                      return DropdownMenuItem(value: e['id'].toString(), child: Text(e['name']));
                    }).toList(), (value) => _selectedRestaurantId = value),
                    const SizedBox(height: 16),
                    _buildDropdown("Penilaian (1-5)", List.generate(5, (index) {
                      return DropdownMenuItem(value: "${index + 1}", child: Text("${index + 1}"));
                    }), (value) => _rating = int.parse(value!)),
                    const SizedBox(height: 16),
                    _buildTextField("Teks Ulasan", "Masukkan teks ulasan", (value) {
                      _teksUlasan = value;
                    }, required: true, maxLines: 4),
                    const SizedBox(height: 16),
                    _buildFilePicker(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
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
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF240F0E)),
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

  Widget _buildDropdown(String label, List<DropdownMenuItem<String>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
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
          child: const Text("Choose File"),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(_selectedFileName, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainReviewPage())),
          child: const Text("Back"),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
