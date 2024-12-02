import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ModalAddBerita extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const ModalAddBerita({super.key, required this.onAdd});

  @override
  _ModalAddBeritaState createState() => _ModalAddBeritaState();
}

class _ModalAddBeritaState extends State<ModalAddBerita> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  Uint8List? _selectedImageBytes; // For Web
  File? _selectedImageFile; // For non-Web
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Handle image selection for Flutter Web
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      } else {
        // Handle image selection for Flutter Mobile/Desktop
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: const Color.fromRGBO(95, 77, 64, 0.95),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(95, 77, 64, 0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF8D7762),
            width: 4,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Tambah Berita",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFFBF2),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFFFFFBF2)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Selected Image or Placeholder
              if (_selectedImageBytes != null || _selectedImageFile != null)
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: kIsWeb
                        ? Image.memory(
                            _selectedImageBytes!,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _selectedImageFile!,
                            fit: BoxFit.cover,
                          ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFFABA197),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Belum ada gambar yang dipilih",
                      style: TextStyle(
                        color: Color(0xFFFFFBF2),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Image Upload Button
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image, color: Colors.black),
                label: const Text(
                  "Pilih Gambar",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE5D2B0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                ),
              ),
              const SizedBox(height: 20),

              // Judul Input
              TextFormField(
                controller: titleController,
                style: const TextStyle(color: Color(0xFFFFFBF2)),
                decoration: InputDecoration(
                  labelText: "Judul",
                  labelStyle: const TextStyle(color: Color(0xFFFFFBF2)),
                  filled: true,
                  fillColor: const Color(0xFFABA197),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFFFFBF2)),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // Konten Input
              TextFormField(
                controller: contentController,
                maxLines: 7,
                style: const TextStyle(color: Color(0xFFFFFBF2)),
                decoration: InputDecoration(
                  labelText: "Konten",
                  labelStyle: const TextStyle(color: Color(0xFFFFFBF2)),
                  filled: true,
                  fillColor: const Color(0xFFABA197),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFFFFBF2)),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Konten wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onAdd({
                          'judul': titleController.text,
                          'konten': contentController.text,
                          'gambar':
                              kIsWeb ? _selectedImageBytes : _selectedImageFile,
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5D2B0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 32),
                    ),
                    child: const Text(
                      "Simpan",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5D2B0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 32),
                    ),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  // Save Button
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
