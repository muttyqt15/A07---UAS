import 'package:flutter/material.dart';
import 'package:uas/models/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReviewCard({
    required this.review,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2C2C2C),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 6.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: review.images.isNotEmpty
                      ? Image.network(
                          review.images.first, // Menggunakan gambar pertama
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey,
                              child: const Icon(Icons.error, color: Colors.red),
                            );
                          },
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey,
                          child: const Icon(Icons.image, color: Colors.white),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.judulUlasan,
                        style: const TextStyle(
                          fontFamily: "Lora",
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Oleh: ${review.teksUlasan}",
                        style: const TextStyle(
                          fontFamily: "Lora",
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.brown[400],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    "${review.penilaian}/5",
                    style: const TextStyle(
                      fontFamily: "Lora",
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Review Title
            Text(
              review.judulUlasan,
              style: const TextStyle(
                fontFamily: "Crimson Pro",
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Review Comment
            Text(
              review.teksUlasan,
              style: const TextStyle(
                fontFamily: "Lora",
                fontSize: 16.0,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            // Date and Likes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${review.tanggal.day} ${_monthName(review.tanggal.month)} ${review.tanggal.year}",
                  style: const TextStyle(
                    fontFamily: "Lora",
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.thumb_up, size: 16, color: Colors.brown),
                    const SizedBox(width: 4),
                    Text(
                      review.totalLikes.toString(),
                      style: const TextStyle(
                        fontFamily: "Lora",
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.brown, height: 20),
            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onEdit,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.brown[400],
                    textStyle: const TextStyle(
                      fontFamily: "Lora",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("Edit"),
                ),
                TextButton(
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    textStyle: const TextStyle(
                      fontFamily: "Lora",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month];
  }
}
