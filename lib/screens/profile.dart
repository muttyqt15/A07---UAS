import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/services/profile.dart';

class Profile {
  final String profilePic;
  final String bio;
  final String email;

  Profile({required this.profilePic, required this.bio, required this.email});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      profilePic: json['fields']['profile_pic'] ?? 'https://via.placeholder.com/150',
      bio: json['fields']['bio'] ?? 'No bio available',
      email: json['fields']['email'] ?? 'No email available',
    );
  }
}

// Dummy JSON data
const String dummyJson = '''
[
  {
    "fields": {
      "profile_pic": "https://via.placeholder.com/150",
      "bio": "Food enthusiast and traveler. Exploring Solo one dish at a time.",
      "email": "customer@example.com"
    }
  }
]
''';

// Method to fetch dummy profile data
Future<List<Profile>> fetchDummyProfile() async {
  final List<dynamic> jsonData = jsonDecode(dummyJson);
  return jsonData.map((item) => Profile.fromJson(item)).toList();
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Profile> futureProfile;
  late Future<List<Profile>> dummyProfile;

  @override
  void initState() {
    super.initState();
    dummyProfile = fetchDummyProfile();
  }

  Future<Profile> fetchProfile(request) async {
    final response = await request.get('http://127.0.0.1:8000/profile/json/');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Profile.fromJson(data[0]); // Assuming the API returns a list of profiles
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override 
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    futureProfile = fetchProfile(request);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MANGAN" SOLO',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF795548),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: FutureBuilder<Profile>(
        future: futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No profile data available'));
          }

          final profile = snapshot.data!;
          return buildProfilePage(profile);
        },
      ),
    );
  }

  Widget buildProfilePage(Profile profile) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background_batik.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profile.profilePic),
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            Text(
              profile.email,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.brown.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(label: 'Email', value: profile.email),
                  const SizedBox(height: 20),
                  buildTextField(label: 'Bio', value: profile.bio, multiline: true),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.brown, width: 1.5),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            buildActionButton('Review Saya', context),
            buildActionButton('Bookmark Saya', context),
            buildActionButton('Lihat Lebih Lanjut', context),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({required String label, required String value, bool multiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.brown.shade300),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            maxLines: multiline ? null : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget buildActionButton(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}
