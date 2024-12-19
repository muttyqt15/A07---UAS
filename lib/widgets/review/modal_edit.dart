import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ModalEdit extends StatefulWidget {
  final int reviewId;
  final String? initialDisplayName;
  final String initialJudul;
  final String initialTeksUlasan;
  final int initialPenilaian;

  const ModalEdit({
    super.key, 
    required this.reviewId,
    this.initialDisplayName,
    required this.initialJudul,
    required this.initialTeksUlasan,
    required this.initialPenilaian,
  });

  @override
  State<ModalEdit> createState() => _ModalEditState();
}

class _ModalEditState extends State<ModalEdit> {
  final _formKey = GlobalKey<FormState>();
  String? _displayName;
  String _judulUlasan = "";
  String _teksUlasan = "";
  int? _rating;
  
  @override
  void initState() {
    super.initState();
    // Set nilai awal form
    _displayName = widget.initialDisplayName;
    _judulUlasan = widget.initialJudul;
    _teksUlasan = widget.initialTeksUlasan;
    _rating = widget.initialPenilaian;
  }

  @override
  Widget build(BuildContext context) {
    const titleColor = Color(0xFF240F0E); 
    const cardColor = Color(0xFFE5D2B0);
    const buttonColor = Color(0xFF5F4D40);

    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            colors: [Color(0xFF8D7762), Color(0xFFE3D6C9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul Form
                    Center(
                      child: Text(
                        "Edit Review",
                        style: TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Display Name (Optional)
                    Text(
                      "Display Name (Optional)",
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _displayName,
                      decoration: InputDecoration(
                        hintText: "Masukkan nama tampil (optional)",
                        hintStyle: const TextStyle(color: Colors.black45),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _displayName = value.isEmpty ? null : value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Judul Ulasan (Wajib)
                    Text(
                      "Judul Ulasan",
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _judulUlasan,
                      decoration: InputDecoration(
                        hintText: "Masukkan judul ulasan",
                        hintStyle: const TextStyle(color: Colors.black45),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _judulUlasan = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Judul ulasan tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Penilaian (1-5)
                    Text(
                      "Penilaian (1-5)",
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      value: _rating,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: [1,2,3,4,5].map((e) {
                        return DropdownMenuItem<int>(
                          value: e,
                          child: Text(e.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Penilaian harus dipilih!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Teks Ulasan
                    Text(
                      "Teks Ulasan",
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _teksUlasan,
                      decoration: InputDecoration(
                        hintText: "Masukkan isi ulasan",
                        hintStyle: const TextStyle(color: Colors.black45),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 4,
                      onChanged: (value) {
                        setState(() {
                          _teksUlasan = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Teks ulasan tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Tombol Back dan Submit
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Back",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final request = context.read<CookieRequest>();
                              final response = await request.postJson(
                                "http://127.0.0.1:8000/review/flutter/edit/${widget.reviewId}/",
                                jsonEncode(<String, dynamic>{
                                  'display_name': _displayName,
                                  'judul_ulasan': _judulUlasan,
                                  'teks_ulasan': _teksUlasan,
                                  'penilaian': _rating,
                                }),
                              );
                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Review berhasil diperbarui!")),
                                  );
                                  Navigator.pop(context, true); 
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Terdapat kesalahan, silakan coba lagi.")),
                                  );
                                }
                              }
                            }
                          },
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
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
    );
  }
}
