import 'package:flutter/material.dart';
import 'package:uas/models/profile.dart';
import 'package:uas/services/profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Profile>> futureProfile;

  @override
  void initState() {
    super.initState();
    futureProfile = ApiService().fetchProfile(); // Fetch the profile data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<List<Profile>>(
        future: futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No profile found'));
          } else {
            final profile = snapshot.data![0]; // Get the first profile, assuming only one profile per user

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profile.fields.profilePic),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Bio: ${profile.fields.bio}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // Display other fields as necessary
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
