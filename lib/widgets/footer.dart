import 'package:flutter/material.dart';
import 'package:uas/screens/news/main_berita.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 192, // Tinggi tetap 192px
      child: Column(
        children: [
          // Box pertama
          Container(
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF7D6E5F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          // Box kedua
          Container(
            height: 164,
            padding: const EdgeInsets.fromLTRB(46, 16, 46, 16),
            color: const Color(0xFF302922),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    Image.asset(
                      'assets/images/logo.png', // Sesuaikan path gambar
                      width: 35,
                      height: 35,
                    ),
                    const SizedBox(width: 10, height: 0,),
                    const Text(
                      'MANGAN" SOLO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                 // 2. Buttons (Restoran, Thread, Berita, Bookmark)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Colors.transparent),
                        foregroundColor:
                            WidgetStateProperty.all(Colors.white),
                        overlayColor: WidgetStateProperty.all(
                            Colors.transparent), // Menghapus efek hover/pressed
                        elevation:
                            WidgetStateProperty.all(0), // Menghapus bayangan
                        shadowColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainBeritaScreen()),
                        );
                      },
                      child: const Text('Restoran', style:
                            TextStyle(fontSize: 12, color: Color(0xFFDECDBE), fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        overlayColor: WidgetStateProperty.all(Colors.transparent), // Menghapus efek hover/pressed
                        elevation: WidgetStateProperty.all(0), // Menghapus bayangan
                        shadowColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainBeritaScreen()),
                        );
                      },
                      child: const Text('Thread', style:
                            TextStyle(fontSize: 12, color: Color(0xFFDECDBE), fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        overlayColor: WidgetStateProperty.all(Colors.transparent), // Menghapus efek hover/pressed
                        elevation: WidgetStateProperty.all(0), // Menghapus bayangan
                        shadowColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainBeritaScreen()),
                        );
                      },
                      child: const Text('Berita', style: TextStyle(fontSize: 12, color: Color(0xFFDECDBE), fontWeight: FontWeight.w600),),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                        foregroundColor: WidgetStateProperty.all(Colors.white),
                        overlayColor: WidgetStateProperty.all(Colors.transparent), // Menghapus efek hover/pressed
                        elevation: WidgetStateProperty.all(0), // Menghapus bayangan
                        shadowColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainBeritaScreen()),
                        );
                      },
                      child: const Text('Bookmark', style:
                            TextStyle(fontSize: 12, color: Color(0xFFDECDBE), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // 3. Text deskripsix
                const Text(
                  '"Kuliner Solo, perpaduan sempurna antara budaya, rasa, dan cinta yang selalu bikin rindu."',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),

                // 4. Hak cipta
                const Center(
                  child: Text(
                    '© 2024 MANGAN" SOLO. All rights reserved.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
