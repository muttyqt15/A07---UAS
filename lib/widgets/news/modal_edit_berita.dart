
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uas/main.dart';

class ModalEditBerita extends StatefulWidget {
  final Function(Map<String, dynamic>, File?, Uint8List?) onEdit;
  final Map<String, dynamic> berita;

  const ModalEditBerita({
    super.key,
    required this.onEdit,
    required this.berita,
  });

  @override
  _ModalEditBeritaState createState() => _ModalEditBeritaState();
}

class _ModalEditBeritaState extends State<ModalEditBerita> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes; // For Web
  String? _selectedImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.berita['judul']);
    contentController = TextEditingController(text: widget.berita['konten']);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // Handle image selection for Flutter Web
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImageFile = null; // File tidak relevan di web
        });
      } else {
        // Handle image selection for Flutter Mobile/Desktop
        setState(() {
          _selectedImageFile = File(pickedFile.path);
          _selectedImageBytes = null; // Bytes tidak relevan di non-web
        });
      }
    }
  }

  void _handleEditBerita() async {
    if (_formKey.currentState!.validate()) {
      String title = titleController.text.trim();
      String content = contentController.text.trim();

      if (title.isEmpty || content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Judul dan Konten tidak boleh kosong."),
            backgroundColor: Colors.red,
          ),
        );
        return; // Hentikan proses jika data kosong
      }

      try {
        Map<String, dynamic> data = {
          'judul': title,
          'konten': content,
        };

        // Validasi gambar
        // if (kIsWeb) {
        //   if (_selectedImageBytes == null) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(
        //         content: Text("Harap pilih gambar."),
        //         backgroundColor: Colors.red,
        //       ),
        //     );
        //     return;
        //   }
        // } else {
        //   if (_selectedImageFile == null) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(
        //         content: Text("Harap pilih gambar."),
        //         backgroundColor: Colors.red,
        //       ),
        //     );
        //     return;
        //   }
        // }

        widget.onEdit(data, _selectedImageFile,
            _selectedImageBytes); // Panggil callback dengan data
        Navigator.of(context).pop(); // Tutup modal setelah sukses
      } catch (e) {
        print('Error editing news in ModalEditBerita: $e');
      }
    } else {
      print("Form validation failed");
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
                    "Edit Berita",
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

              // Current or Selected Image
              if (_selectedImageBytes != null) // Gambar baru untuk web
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      _selectedImageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else if (_selectedImageFile != null) // Gambar baru untuk mobile
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImageFile!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else if (widget.berita['gambar'] != null) // Gambar asli
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      '${CONSTANTS.baseUrl}/${widget.berita['gambar']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else // Placeholder jika tidak ada gambar
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
                    onPressed: _handleEditBerita,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
