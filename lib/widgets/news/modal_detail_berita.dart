import 'package:flutter/material.dart';
import 'package:uas/models/news.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uas/widgets/news/like_button.dart';

class ModalDetailBerita extends StatelessWidget {
  final News news;

  const ModalDetailBerita({super.key, required this.news});

  String formatTanggal(String rawDate) {
    initializeDateFormatting('id_ID');
    try {
      final DateTime parsedDate = DateTime.parse(rawDate).toLocal();
      return DateFormat("d MMMM y", "id_ID").format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50), // Jarak dari atas
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20), // Margin samping
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF8D7762),
              Color(0xFFE3D6C9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(95, 77, 64, 0.80),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: const Color(0xFF8D7762),
              width: 4,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  news.fields.judul,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFFBF2),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'http://127.0.0.1:8000/${news.fields.gambar}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 20),

                // Tanggal dan Konten
                Text(
                  "Tanggal Rilis: ${formatTanggal(news.fields.tanggal.toString())}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFBF2),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Last Update: ${formatTanggal(news.fields.tanggalPembaruan.toString())}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFFFFBF2),
                  ),
                ),
                const SizedBox(height: 20),

                // Konten
                const Text(
                  "Konten",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFFBF2),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  news.fields.konten,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFFBF2),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),

                // Author dan Likes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Oleh: ${news.fields.author}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFFFBF2),
                      ),
                    ),
                    // Text(
                    //   "${news.fields.like} Likes",
                    //   style: const TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w500,
                    //     color: Color(0xFFFFFBF2),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 20),

                // Tombol Like dan Tutup
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LikeButton(
                      beritaId: news.pk, // ID berita
                      isLiked: news.fields.liked, // Status awal (bisa diambil dari API jika ada)
                      initialLikes: news.fields.like, // Jumlah likes
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5D2B0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Tutup",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
