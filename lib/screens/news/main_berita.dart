import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas/screens/news/main_owner_berita.dart';
import 'package:uas/widgets/footer.dart';
import 'package:uas/widgets/news/berita_card.dart';
import 'package:uas/models/news.dart';
import 'package:uas/services/news/news_services.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';


class MainBeritaScreen extends StatefulWidget {
  @override
  _MainBeritaScreenState createState() => _MainBeritaScreenState();
}

class _MainBeritaScreenState extends State<MainBeritaScreen> {
  static const String baseUrl = 'http://localhost:8000';
  final NewsServices _beritaService = NewsServices();
  List<News> _beritaList = [];
  String _sortBy = 'like';
  bool _isLoading = false;
  bool _isOwner = false; // Untuk menentukan apakah user adalah restoran owner

  @override
  void initState() {
    super.initState();
    fetchBerita();
    checkUserRole(); // Periksa apakah user adalah restoran owner
  }

  Future<void> fetchBerita() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    try {
      final berita = await _beritaService.fetchBerita(request);
      setState(() {
        _beritaList = berita;
        _sortBerita(_sortBy);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching berita: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> checkUserRole() async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    String url = '$baseUrl/news/get_user_role/';
    try {
      final response = await request.get(url); // Endpoint role
      setState(() {
        _isOwner = response['is_owner'] ??
            false; // Asumsikan response memiliki `is_owner`
      });
    } catch (e) {
      print('Error checking user role: $e');
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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Stack(
              children: [
                // Image Layer
                Image.asset(
                  'assets/images/batik.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Dark Overlay
                Container(
                  color: Colors.black.withOpacity(0.7), // 70% dark overlay
                ),
              ],
            ),
          ),
          ListView(
            children: [
              // Jika user adalah restoran owner, tambahkan tombol
              if (_isOwner)
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                              "Pemilik Restoran?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Crimson Pro",
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color(0xFFD7C3B0),
                                      Color(0xFFFFFBF2)
                                    ],
                                  ).createShader(
                                      const Rect.fromLTWH(0, 0, 300, 0)),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Subtitle
                            const Text(
                              "Bagikan Informasi Terkini Terkait Restoran Anda Melalui Berita!",
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainOwnerBerita(),
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
                                "Kelola Berita Restoran",
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _beritaList.length,
                itemBuilder: (context, index) {
                  return BeritaCard(
                    key: ValueKey(_beritaList[index].pk),
                    news: _beritaList[index],
                    onLikeToggled: fetchBerita, // Refetch berita
                  );
                },
              ),

              const SizedBox(height: 10),
              const AppFooter(),
            ],
          ),
        ],
      ),
    );
  }
}
