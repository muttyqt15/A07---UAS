import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/main.dart';
import 'package:uas/screens/authentication/login.dart';
import 'package:uas/screens/bookmark/bookmark_list.dart';
import 'package:uas/screens/landing.dart';
import 'package:uas/screens/news/main_berita.dart';
import 'package:uas/screens/profile/profile.dart';
import 'package:uas/screens/thread/thread.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch state from CookieRequest
    final request = context.watch<CookieRequest>();
    final isLoggedIn = request.loggedIn ?? false;
    final role = isLoggedIn ? (request.getJsonData()?['data']?['role'] ?? '') : '';

    Future<void> _handleLogout() async {
      try {
        // Perform logout request
        final response = await request.post("${CONSTANTS.baseUrl}/auth/flogout/", {});
        if (response['success'] == true) {
          // Update state in CookieRequest to reflect logout
          request.loggedIn = false; // Trigger rebuild for dependent widgets
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out successfully!')),
          );
          // Redirect to landing page and clear navigation stack
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LandingPage()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout failed: ${response['message']}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during logout: $e')),
        );
      }
    }

    return Drawer(
      child: ListView(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Column(
              children: [
                Text(
                  'Mangan" Solo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Text(
                  "Makan lezat, yuk!",
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

          // Menu: Profile/Login
          ListTile(
            leading: const Icon(Icons.person_3_rounded, color: Colors.black87),
            title: Text(
              isLoggedIn ? 'Profile' : 'Login',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      isLoggedIn ? ProfilePage() : const LoginPage(),
                ),
              );
            },
          ),

          // Menu: Halaman Utama
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Halaman Utama'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LandingPage()),
              );
            },
          ),

          // Menu: News
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('News'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainBeritaScreen()),
              );
            },
          ),

          // Additional Menus for Logged In Users
          if (isLoggedIn) ...[
            // Menu: Thread
            ListTile(
              leading: const Icon(Icons.forum),
              title: const Text('Thread'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ThreadScreen()),
                );
              },
            ),

            // Menu: Bookmark (only for role 'CUSTOMER')
            if (role == 'CUSTOMER')
              ListTile(
                leading: const Icon(Icons.bookmark_add_outlined),
                title: const Text('Bookmark'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookmarkListScreen()),
                  );
                },
              ),

            // Menu: Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _handleLogout,
            ),
          ],
        ],
      ),
    );
  }
}
