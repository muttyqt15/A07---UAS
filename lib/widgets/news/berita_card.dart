import 'package:flutter/material.dart';
import 'package:uas/main.dart';
import 'package:uas/models/news.dart';
import 'package:uas/widgets/news/like_button.dart';
import 'modal_detail_berita.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class BeritaCard extends StatelessWidget {
  final News news;
  final VoidCallback onLikeToggled;

  const BeritaCard({
    super.key,
    required this.news,
    required this.onLikeToggled,
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
        child: CustomPaint(
          painter: GradientBorderPainter(
            borderRadius: 40.0,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF8D7762), // Warna awal
                Color(0xFFE3D6C9), // Warna akhir
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            strokeWidth: 6.0,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(40, 40, 34, 40),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(95, 77, 64, 0.80),
              borderRadius: BorderRadius.circular(40),
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
                      '${CONSTANTS.baseUrl}${news.fields.gambar}',
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
                    LikeButton(
                      key: ValueKey(
                          news.pk), // Tambahkan key unik berdasarkan ID berita
                      beritaId: news.pk, // ID berita
                      isLiked: news.fields.liked, // Status awal
                      initialLikes: news.fields.like, // Jumlah likes
                      onToggleLikeComplete: onLikeToggled, // Callback
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Detail Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => ModalDetailBerita(
                          beritaId: news.pk,
                          onModalClosed: onLikeToggled,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE5D2B0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 32),
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
                        height: 1.4,
                        color: Color(0xFF5F4D40),
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

class GradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final Gradient gradient;
  final double strokeWidth;

  GradientBorderPainter({
    required this.borderRadius,
    required this.gradient,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final RRect rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
