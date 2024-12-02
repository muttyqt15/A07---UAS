import 'package:flutter/material.dart';
import 'package:uas/widgets/footer.dart';
import '/widgets/news/berita_owner_card.dart';
import '/widgets/news/modal_remove_berita.dart';
import '/widgets/news/modal_edit_berita.dart';
import '/widgets/news/modal_add_berita.dart';
import '/services/news/news_owner_services.dart';

class MainOwnerBerita extends StatefulWidget {
  @override
  _MainOwnerBeritaState createState() => _MainOwnerBeritaState();
}

class _MainOwnerBeritaState extends State<MainOwnerBerita> {
  List<dynamic> _beritaList = [];
  String _sortBy = "like";
  bool _isLoading = false;
  final newsOwnerServices = NewsOwnerServices();

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    try {
      final news = await newsOwnerServices.fetchNews();
      setState(() {
        _beritaList = news;
      });
    } catch (e) {
      print('Error loading news: $e');
    }
  }

  void _addNews(Map<String, dynamic> data) async {
    // await newsOwnerServices.addNews(data);
    _loadNews();
  }

  void _editNews(String id, Map<String, dynamic> data) async {
    // await newsOwnerServices.editNews(id, data);
    _loadNews();
  }

  void _deleteNews(String id) async {
    await newsOwnerServices.deleteNews(id);
    _loadNews();
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
          // Header Section
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            padding: const EdgeInsets.fromLTRB(40, 18, 40, 18),
            decoration: BoxDecoration(
              color: const Color(0xFF5F4D40),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 313,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        "Berita",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Crimson Pro",
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [Color(0xFFD7C3B0), Color(0xFFFFFBF2)],
                            ).createShader(const Rect.fromLTWH(0, 0, 300, 0)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Subtitle
                      const Text(
                        "Bagikan Pengalaman Anda dengan Restoran Kami Melalui Berita!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Crimson Pro",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFFBF2),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Write News Button
                      ElevatedButton(
                        onPressed: () {
                          
                          showDialog(
                            context: context,
                            builder: (context) => ModalAddBerita(
                              onAdd: (data) {
                                _addNews(
                                    data); // Panggil fungsi untuk menambahkan berita
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA18971),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Text(
                          "Tulis Berita",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

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
              final berita = _beritaList[index];
              return BeritaOwnerCard(
                news: berita,
                onEdit: () {
                  showDialog(
                    context: context,
                    builder: (_) => ModalEditBerita(
                      berita:
                          berita.fields.toMap(), // Konversi Fields menjadi Map
                      onEdit: (data) =>
                          _editNews(berita.pk, data), // Gunakan PK untuk ID
                    ),
                  );
                },
                onRemove: () {
                  showDialog(
                    context: context,
                    builder: (_) => ModalRemoveBerita(
                      onDelete: () => _deleteNews(berita.pk),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 10),
          const AppFooter(),
        ],
      ),
    );
  }
}
