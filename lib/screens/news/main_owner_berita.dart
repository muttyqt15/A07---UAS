import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas/widgets/footer.dart';
import '/widgets/news/berita_owner_card.dart';
import '/widgets/news/modal_remove_berita.dart';
import '/widgets/news/modal_edit_berita.dart';
import '/widgets/news/modal_add_berita.dart';
import '/services/news/news_owner_services.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

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
    final request = Provider.of<CookieRequest>(context, listen: false);
    try {
      final news = await newsOwnerServices.fetchNews(request);
      setState(() {
        _beritaList = news;
      });
    } catch (e) {
      print('Error loading news: $e');
    }
  }

  void _addNews(Map<String, dynamic> data) async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    try {
      await newsOwnerServices.addNews(
        request,
        title: data['title']!,
        content: data['content']!,
      );
      _loadNews(); // Refresh daftar berita
    } catch (e) {
      print('Error adding news in MainOwnerBerita: $e');
    }
  }


  void _editNews(String id, Map<String, dynamic> data) async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    try {
      await newsOwnerServices.editNews(
        request,
        id: id,
        title: data['judul'],
        content: data['konten'],
      );
      _loadNews(); // Refresh daftar berita setelah edit
    } catch (e) {
      print('Error editing news: $e');
    }
  }

  void _deleteNews(String id) async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    try {
      await newsOwnerServices.deleteNews(request, id);
      _loadNews();
    } catch (e) {
      print('Error deleting news: $e');
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
                                _addNews(data);
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

          // List of News
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _beritaList.length,
            itemBuilder: (context, index) {
              final berita = _beritaList[index];
              return BeritaOwnerCard(
                key: ValueKey(berita.pk), // Tambahkan key unik
                news: berita,
                onEdit: () {
                  showDialog(
                    context: context,
                    builder: (context) => ModalEditBerita(
                      berita: berita.fields.toMap(),
                      onEdit: (data) => _editNews(berita.pk, data),
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
