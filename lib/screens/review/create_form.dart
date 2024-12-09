import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uas/screens/landing.dart';
import 'package:uas/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewFormPage extends StatefulWidget {
  const ReviewFormPage({super.key});

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _judulUlasan = "";
  String _teksUlasan = "";
  int _penilaian = 1;
  DateTime _tanggal = DateTime.now();
  int _totalLikes = 0;
  List<String> _images = [];
  String? _selectedRestaurantId;  // Store the selected restaurant ID
  List<Map<String, dynamic>> _restaurants = [];  // List of restaurants

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();  // Fetch the restaurants on init
  }

  // Function to fetch the list of restaurants from the backend
  Future<void> _fetchRestaurants() async {
    final request = context.read<CookieRequest>();
    final response = await request.get("http://127.0.0.1:8000/api/restaurants/");

    if (response['status'] == 'success') {
      setState(() {
        _restaurants = List<Map<String, dynamic>>.from(response['data']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to fetch restaurants, please try again."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Form Tambah Review')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(), // Drawer
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Ulasan
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Judul Ulasan",
                      labelText: "Judul Ulasan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
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
                ),
                // Teks Ulasan
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Teks Ulasan",
                      labelText: "Teks Ulasan",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
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
                ),
                // Penilaian (Rating)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Penilaian (1-5)",
                      labelText: "Penilaian",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _penilaian = int.tryParse(value) ?? 1;
                      });
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Tanggal (YYYY-MM-DD)",
                      labelText: "Tanggal",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    keyboardType: TextInputType.datetime,
                    onChanged: (value) {
                      setState(() {
                        _tanggal = DateTime.tryParse(value) ?? DateTime.now();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Tanggal tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                // Total Likes
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Total Likes",
                      labelText: "Total Likes",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _totalLikes = int.tryParse(value) ?? 0;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Total Likes tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                // Restaurant Dropdown
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _restaurants.isEmpty
                      ? const CircularProgressIndicator()  // Show loading indicator
                      : DropdownButtonFormField<String>(
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
                // Image URLs (for simplicity)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Image URL (separate by commas)",
                      labelText: "Image URLs",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _images = value.split(',').map((e) => e.trim()).toList();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Image URL tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                // Save Button
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.blueAccent;  // Warna saat tombol ditekan
                          }
                          return Theme.of(context).colorScheme.primary;  // Warna default
                        }),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final response = await request.postJson(
                            "http://127.0.0.1:8000/create-flutter/",
                            jsonEncode(<String, dynamic>{
                              'judul_ulasan': _judulUlasan,
                              'teks_ulasan': _teksUlasan,
                              'penilaian': _penilaian,
                              'tanggal': _tanggal.toIso8601String(),
                              'total_likes': _totalLikes,
                              'images': _images,
                              'restaurant_id': _selectedRestaurantId,  // Send the selected restaurant ID
                            }),
                          );
                          if (context.mounted) {
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Review berhasil disimpan!")),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LandingPage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Terdapat kesalahan, silakan coba lagi.")),
                              );
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
