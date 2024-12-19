import 'package:flutter/material.dart';
import 'package:uas/models/news.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uas/widgets/news/like_button.dart';
import 'package:uas/services/news/news_services.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class ModalDetailBerita extends StatefulWidget {
  final String beritaId; // ID berita untuk fetch data

  const ModalDetailBerita({super.key, required this.beritaId});

  @override
  _ModalDetailBeritaState createState() => _ModalDetailBeritaState();
}
class _ModalDetailBeritaState extends State<ModalDetailBerita> {
  News? _news; // Tidak menggunakan late
  bool _isLoading = true;

  String formatTanggal(String rawDate) {
    initializeDateFormatting('id_ID');
    try {
      final DateTime parsedDate = DateTime.parse(rawDate).toLocal();
      return DateFormat("d MMMM y", "id_ID").format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  Future<void> fetchBeritaDetail() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final newsService = NewsServices();

    setState(() {
      _isLoading = true;
    });

    try {
      final berita =
          await newsService.fetchBeritaById(request, widget.beritaId);
      setState(() {
        _news = berita;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching berita detail: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchBeritaDetail();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _news == null
            ? const Center(child: Text('Berita tidak ditemukan'))
            : Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8D7762), Color(0xFFE3D6C9)],
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
                          Text(
                            _news?.fields.judul ?? "Judul tidak tersedia",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFFFBF2),
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_news?.fields.gambar != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                'http://127.0.0.1:8000/${_news?.fields.gambar}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                          const SizedBox(height: 20),
                          Text(
                            "Tanggal Rilis: ${formatTanggal(_news?.fields.tanggal.toString() ?? "")}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFBF2),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Last Update: ${formatTanggal(_news?.fields.tanggalPembaruan.toString() ?? "")}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFBF2),
                            ),
                          ),
                          const SizedBox(height: 20),
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
                            _news?.fields.konten ?? "Konten tidak tersedia",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFFFFBF2),
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Oleh: ${_news?.fields.author ?? "Tidak diketahui"}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFFBF2),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LikeButton(
                                beritaId: _news?.pk ?? "",
                                isLiked: _news?.fields.liked ?? false,
                                initialLikes: _news?.fields.like ?? 0,
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
