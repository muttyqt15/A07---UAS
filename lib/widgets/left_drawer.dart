import 'package:flutter/material.dart';
import 'package:uas/screens/landing.dart';
import 'package:uas/screens/news/main_berita.dart';
import 'package:uas/screens/thread/thread.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Floryn Shop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Sempurnakan momen istimewa Anda dengan bunga indah dari Floryn Shop!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LandingPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(IconData(0xf0541, fontFamily: 'MaterialIcons')),
            title: const Text('Berita'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainBeritaScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(IconData(0xf0541, fontFamily: 'MaterialIcons')),
            title: const Text('Thread'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThreadScreen(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
