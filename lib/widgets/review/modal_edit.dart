import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ModalEditReview extends StatefulWidget {
  final String reviewId;
  final String initialJudulUlasan;
  final String initialTeksUlasan;
  final int initialPenilaian;
  final String initialDisplayName;
  final List<String> initialImages;

  const ModalEditReview({
    Key? key,
    required this.reviewId,
    required this.initialJudulUlasan,
    required this.initialTeksUlasan,
    required this.initialPenilaian,
    required this.initialDisplayName,
    required this.initialImages,
  }) : super(key: key);

  @override
  State<ModalEditReview> createState() => _ModalEditReviewState();
}

class _ModalEditReviewState extends State<ModalEditReview> {
  final _formKey = GlobalKey<FormState>();
  late String judulUlasan;
  late String teksUlasan;
  late int penilaian;
  late String displayName;
  late List<String> images;
  Uint8List? newImageBytes;
  File? newImageFile;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    judulUlasan = widget.initialJudulUlasan;
    teksUlasan = widget.initialTeksUlasan;
    penilaian = widget.initialPenilaian;
    displayName = widget.initialDisplayName;
    images = List.from(widget.initialImages);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          newImageBytes = bytes;
          newImageFile = null;
        });
      } else {
        setState(() {
          newImageFile = File(pickedFile.path);
          newImageBytes = null;
        });
      }
    }
  }

  Widget _buildImageWidget() {
    if (kIsWeb && newImageBytes != null) {
      return Image.memory(newImageBytes!, fit: BoxFit.cover, height: 100, width: 100);
    } else if (newImageFile != null) {
      return Image.file(newImageFile!, fit: BoxFit.cover, height: 100, width: 100);
    }
    return const Placeholder(fallbackHeight: 100, fallbackWidth: 100);
  }

  Future<void> _submitEdit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final request = context.read<CookieRequest>();
    final Map<String, dynamic> body = {
      "judul_ulasan": judulUlasan,
      "teks_ulasan": teksUlasan,
      "penilaian": penilaian.toString(),
      "display_name": displayName.isNotEmpty ? displayName : "Anonymous",
    };

    if (newImageBytes != null) {
      body["new_image_base64"] = "data:image/jpeg;base64,${base64Encode(newImageBytes!)}";
    }

    try {
      final response = await request.postJson(
        "http://localhost:8000/review/flutter/edit/${widget.reviewId}/",
        jsonEncode(body),
      );

      if (response["status"] == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Review berhasil diperbarui!")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Gagal memperbarui review.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8D7762), Color(0xFFE3D6C9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8D7762).withOpacity(0.3),
                spreadRadius: 0.2,
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE5D2B0),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Edit Review",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5F4D40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: judulUlasan,
                        decoration: const InputDecoration(labelText: "Judul Ulasan"),
                        onChanged: (value) => judulUlasan = value,
                        validator: (value) =>
                            value!.isEmpty ? "Judul ulasan tidak boleh kosong!" : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: displayName,
                        decoration: const InputDecoration(labelText: "Display Name (Opsional)"),
                        onChanged: (value) => displayName = value,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<int>(
                        value: penilaian,
                        decoration: const InputDecoration(labelText: "Penilaian"),
                        items: [1, 2, 3, 4, 5]
                            .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                            .toList(),
                        onChanged: (value) => setState(() => penilaian = value!),
                        validator: (value) =>
                            value == null ? "Penilaian harus dipilih!" : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: teksUlasan,
                        decoration: const InputDecoration(labelText: "Komentar"),
                        maxLines: 4,
                        onChanged: (value) => teksUlasan = value,
                        validator: (value) =>
                            value!.isEmpty ? "Komentar tidak boleh kosong!" : null,
                      ),
                      const SizedBox(height: 16),
                      const Text("Gambar Lama:"),
                      Wrap(
                        spacing: 8,
                        children: images
                            .map(
                              (url) => Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Image.network(
                                    url,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        images.remove(url);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      const Text("Gambar Baru:"),
                      _buildImageWidget(),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add),
                        label: const Text("Tambah Gambar"),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal"),
                          ),
                          ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitEdit,
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Simpan"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}