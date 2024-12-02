import 'package:flutter/material.dart';
import 'package:uas/models/news.dart';
import 'package:uas/widgets/news/like_button.dart';
import 'modal_detail_berita.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class BeritaOwnerCard extends StatelessWidget {
  final News news;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const BeritaOwnerCard({
    super.key,
    required this.news,
    required this.onEdit,
    required this.onRemove,
  });

  String formatTanggal() {
    initializeDateFormatting('id_ID');
    var rawDate = news.fields.tanggal.toString();
    try {
      final DateTime parsedDate = DateTime.parse(rawDate).toLocal();
      final String formattedDate =
          DateFormat("d MMMM y", "id_ID").format(parsedDate);
      return formattedDate;
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(20),
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
          padding: const EdgeInsets.fromLTRB(40, 40, 34, 40),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(95, 77, 64, 0.80),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: const Color(0xFF8D7762),
              width: 4,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Container(
                width: double.infinity,
                height: 171,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'http://127.0.0.1:8000/${news.fields.gambar}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                news.fields.judul,
                style: const TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                  color: Color(0xFFFFFBF2),
                ),
              ),
              const SizedBox(height: 10),

              // Release Date
              Text(
                "Dirilis pada Tanggal - ${formatTanggal()}",
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: Color(0xFFFFFBF2),
                ),
              ),
              const SizedBox(height: 10),

              // Author
              Text(
                "Oleh: ${news.fields.author}",
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: Color(0xFFFFFBF2),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),

              // Like Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(""),
                  // Text(
                  //   "${news.fields.like} Likes",
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     fontStyle: FontStyle.normal,
                  //     fontWeight: FontWeight.w500,
                  //     height: 1.4,
                  //     color: Color(0xFFFFFBF2),
                  //   ),
                  // ),
                  LikeButton(
                    beritaId: news.pk, // ID berita
                    isLiked: news.fields.liked, // Status awal (bisa diambil dari API jika ada)
                    initialLikes: news.fields.like, // Jumlah likes
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Detail, Edit, and Remove Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Detail Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => ModalDetailBerita(news: news),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5D2B0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Lihat Rincian",
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5F4D40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Edit Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onEdit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5D2B0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Edit Berita",
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5F4D40),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Remove Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onRemove,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5D2B0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        "Hapus Berita",
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5F4D40),
                        ),
                      ),
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