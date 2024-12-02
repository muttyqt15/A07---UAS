import 'package:flutter/material.dart';
import 'package:uas/widgets/footer.dart';
import 'package:uas/widgets/news/berita_card.dart';
import 'package:uas/models/news.dart';
import 'package:uas/services/news/news_services.dart';

class MainBeritaScreen extends StatefulWidget {
  @override
  _MainBeritaScreenState createState() => _MainBeritaScreenState();
}

class _MainBeritaScreenState extends State<MainBeritaScreen> {
  final NewsServices _beritaService = NewsServices();
  List<News> _beritaList = []; // Daftar berita yang akan ditampilkan
  String _sortBy = 'like';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchBerita();
  }

  Future<void> fetchBerita() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final berita = await _beritaService.fetchBerita();
      setState(() {
        _beritaList = berita;
        _sortBerita(_sortBy);
      });
    } catch (e) {
      // Tampilkan error ke user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching berita: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sortBerita(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      if (sortBy == 'like') {
        _beritaList.sort((a, b) => b.fields.like.compareTo(a.fields.like));
      } else if (sortBy == 'tanggal') {
        _beritaList.sort((a, b) => DateTime.parse(b.fields.tanggal.toString())
            .compareTo(DateTime.parse(a.fields.tanggal.toString())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Berita')),
      body: ListView(
        children: [
          // Daftar Berita Header
          Text(
            "Daftar Berita",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1.2,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [Color(0xFFD7C3B0), Color(0xFFFFFBF2)],
                ).createShader(const Rect.fromLTWH(0, 0, 300, 0)),
            ),
          ),
          const SizedBox(height: 20),

          // Sorting Buttons
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF44392F),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sort by Like Button
                GestureDetector(
                  onTap: () => _sortBerita('like'),
                  child: Container(
                    width: 120,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _sortBy == 'like'
                          ? const Color(0xFFDECDBE)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: const Color(0xFFFFFBF2),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "Sort by Like",
                      style: TextStyle(
                        fontFamily: "Lora",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: _sortBy == 'like'
                            ? const Color(0xFF5F4D40)
                            : const Color(0xFFFFFBF2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Sort by Date Button
                GestureDetector(
                  onTap: () => _sortBerita('tanggal'),
                  child: Container(
                    width: 120,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _sortBy == 'tanggal'
                          ? const Color(0xFFDECDBE)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: const Color(0xFFFFFBF2),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      "Sort by Date",
                      style: TextStyle(
                        fontFamily: "Lora",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: _sortBy == 'tanggal'
                            ? const Color(0xFF5F4D40)
                            : const Color(0xFFFFFBF2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // List of News
          ListView.builder(
            shrinkWrap: true, // Important to allow nesting ListView in ListView
            physics:
                const NeverScrollableScrollPhysics(), // Disable inner scrolling
            itemCount: _beritaList.length,
            itemBuilder: (context, index) {
              return BeritaCard(news: _beritaList[index]);
            },
          ),

          const SizedBox(height: 10),
          const  AppFooter(),
        ],
      ),
    );
  }
}
