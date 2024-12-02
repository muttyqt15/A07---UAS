// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class ModalEditBerita extends StatefulWidget {
//   final Function(Map<String, dynamic>) onEdit;
//   final Map<String, dynamic> berita;

//   const ModalEditBerita(
//       {super.key, required this.onEdit, required this.berita});

//   @override
//   _ModalEditBeritaState createState() => _ModalEditBeritaState();
// }

// class _ModalEditBeritaState extends State<ModalEditBerita> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController titleController;
//   late TextEditingController contentController;
//   File? _selectedImage;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     titleController = TextEditingController(text: widget.berita['judul']);
//     contentController = TextEditingController(text: widget.berita['konten']);
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       backgroundColor: const Color.fromRGBO(95, 77, 64, 0.95),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: const Color.fromRGBO(95, 77, 64, 0.95),
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: const Color(0xFF8D7762),
//             width: 3,
//           ),
//         ),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Title
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     "Edit Berita",
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFFFFFBF2),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close, color: Color(0xFFFFFBF2)),
//                     onPressed: () => Navigator.of(context).pop(),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Current Image
//               if (widget.berita['gambar'] != null && _selectedImage == null)
//                 Container(
//                   width: double.infinity,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.network(
//                       'http://127.0.0.1:8000/${widget.berita['gambar']}',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               if (_selectedImage != null)
//                 Container(
//                   width: double.infinity,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.file(
//                       _selectedImage!,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               const SizedBox(height: 16),

//               // Image Upload Button
//               ElevatedButton.icon(
//                 onPressed: _pickImage,
//                 icon: const Icon(Icons.image, color: Colors.black),
//                 label: const Text(
//                   "Pilih Gambar",
//                   style: TextStyle(color: Colors.black),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFE5D2B0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Judul Input
//               TextFormField(
//                 controller: titleController,
//                 style: const TextStyle(color: Color(0xFFFFFBF2)),
//                 decoration: InputDecoration(
//                   labelText: "Judul",
//                   labelStyle: const TextStyle(color: Color(0xFFFFFBF2)),
//                   filled: true,
//                   fillColor: const Color(0xFFABA197),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(color: Color(0xFFFFFBF2)),
//                   ),
//                 ),
//                 validator: (value) =>
//                     value!.isEmpty ? "Judul wajib diisi" : null,
//               ),
//               const SizedBox(height: 16),

//               // Konten Input
//               TextFormField(
//                 controller: contentController,
//                 maxLines: 4,
//                 style: const TextStyle(color: Color(0xFFFFFBF2)),
//                 decoration: InputDecoration(
//                   labelText: "Konten",
//                   labelStyle: const TextStyle(color: Color(0xFFFFFBF2)),
//                   filled: true,
//                   fillColor: const Color(0xFFABA197),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(color: Color(0xFFFFFBF2)),
//                   ),
//                 ),
//                 validator: (value) =>
//                     value!.isEmpty ? "Konten wajib diisi" : null,
//               ),
//               const SizedBox(height: 20),

//               // Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   // Cancel Button
//                   ElevatedButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFE5D2B0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(40),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 32),
//                     ),
//                     child: const Text(
//                       "Batal",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//                   // Save Button
//                   ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         widget.onEdit({
//                           'judul': titleController.text,
//                           'konten': contentController.text,
//                           'gambar': _selectedImage,
//                         });
//                         Navigator.of(context).pop();
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFC1A386),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(40),
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 32),
//                     ),
//                     child: const Text(
//                       "Simpan",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ModalEditBerita extends StatefulWidget {
  final Function(Map<String, dynamic>) onEdit;
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
        // Use network URL or web-compatible logic
        setState(() {
          _selectedImageUrl = pickedFile.path; // Temporary path for Flutter Web
        });
      } else {
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
              if (widget.berita['gambar'] != null &&
                  _selectedImageFile == null &&
                  _selectedImageUrl == null)
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'http://127.0.0.1:8000/${widget.berita['gambar']}',
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else if (_selectedImageFile != null)
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
              else if (_selectedImageUrl != null)
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      _selectedImageUrl!,
                      fit: BoxFit.cover,
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
                  // Cancel Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onEdit({
                          'judul': titleController.text,
                          'konten': contentController.text,
                          'gambar': _selectedImageFile ?? _selectedImageUrl,
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
