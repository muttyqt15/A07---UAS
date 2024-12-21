import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas/models/profile.dart';
// import 'package:uas/services/profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:uas/screens/authentication/login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
late Future<Profile> futureProfile;
  //   bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<Profile> fetchProfile() async {
    final request = context.read<CookieRequest>();
    final res =
          await request.get("http://localhost:8000/profile/fetch_profile/");
      var data = res;
      print('Raw PROFILE response: $res'); // Debug print

      Profile profile = Profile.fromJson(data['profile']);
      return profile;    
  }

  Future<void> editProfile(CookieRequest request, String newBio) async {
    final response = await request.post(
      "http://localhost:8000/profile/edit_profile_flutter/",
      jsonEncode({'bio': newBio}),
    );

    if (response['success']) {
      setState(() {
        futureProfile = fetchProfile();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${response['message']}')),
      );
    }
  }

  Future<void> deleteAccount(CookieRequest request) async {
    final response = await request.post(
      "http://localhost:8000/profile/delete_account_flutter/",
      jsonEncode({}),
    );

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: ${response['message']}')),
      );
    }
  }

  Future<void> editProfilePicture(CookieRequest request, String profilePicUrl) async {
    final response = await request.post(
      "http://localhost:8000/profile/edit_profile_picture_flutter/",
      jsonEncode({'profile_pic_url': profilePicUrl}),
    );

    if (response['success']) {
      setState(() {
        futureProfile = fetchProfile();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile picture updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile picture: ${response['error']}')),
      );
    }
  }

  void showEditDialog(Profile profile) {
  final request = context.read<CookieRequest>();
  TextEditingController bioController = TextEditingController(text: profile.bio);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Color(0xFFF5E6D3), // Soft beige
        title: Text(
          'Edit Bio',
          style: TextStyle(
            fontFamily: 'Poppins', 
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: Color(0xFF4E342E), // Dark brown
          ),
        ),
        content: TextField(
          controller: bioController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Enter your new bio',
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF4E342E),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4E342E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              editProfile(request, bioController.text);
              Navigator.of(context).pop();
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}

  void showDeleteDialog() {
    final request = context.read<CookieRequest>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFFF5E6D3), // Soft beige
          title: Text(
            'Delete Account',
            style: TextStyle(
              fontFamily: 'Poppins', 
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Color(0xFF4E342E), // Dark brown
            ),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF4E342E),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color(0xFF4E342E),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4E342E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                deleteAccount(request);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showEditProfilePicDialog() {
    final request = context.read<CookieRequest>();
    TextEditingController profilePicUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Color(0xFFF5E6D3), // Soft beige
          title: Text(
            'Edit Profile Picture',
            style: TextStyle(
              fontFamily: 'Poppins', 
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Color(0xFF4E342E), // Dark brown
            ),
          ),
          content: TextField(
            controller: profilePicUrlController,
            decoration: InputDecoration(
              hintText: 'Enter the URL of your new profile picture',
              filled: true,
              fillColor: Colors.white,
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Color(0xFF4E342E),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4E342E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                editProfilePicture(request, profilePicUrlController.text);
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  // void showEditDialog(Profile profile) {
  //   final request = context.read<CookieRequest>();
  //   TextEditingController bioController = TextEditingController(text: profile.bio);

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Edit Bio'),
  //         content: TextField(
  //           controller: bioController,
  //           maxLines: 3,
  //           decoration: InputDecoration(
  //             hintText: 'Enter your new bio',
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               editProfile(request, bioController.text);
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void showDeleteDialog() {
  //   final request = context.read<CookieRequest>();

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Delete Account'),
  //         content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               deleteAccount(request);
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Delete'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void showEditProfilePicDialog() {
  //   final request = context.read<CookieRequest>();
  //   TextEditingController profilePicUrlController = TextEditingController();

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Edit Profile Picture'),
  //         content: TextField(
  //           controller: profilePicUrlController,
  //           decoration: InputDecoration(
  //             hintText: 'Enter the URL of your new profile picture',
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               editProfilePicture(request, profilePicUrlController.text);
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
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
        future: fetchProfile(),
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
          image: AssetImage('assets/images/batik.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.8), // Adjust the opacity as needed
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profile.profilePic ?? 'https://via.placeholder.com/150'),
                  backgroundColor: Colors.grey.shade300,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: showEditProfilePicDialog,
                          child: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color.fromARGB(179, 62, 0, 0),
                            child: Icon(Icons.camera_alt_outlined, color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile.username,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                          onPressed: () {
                            showEditDialog(profile);
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              if (profile.role == 'customer') ...[
                buildActionButton('Review Saya', context),
                buildActionButton('Bookmark Saya', context),
                buildActionButton('Hapus Akun', context, ),
              ] else if (profile.role == 'restaurant_owner') ...[
                buildActionButton('Resto Saya', context),
                buildActionButton('Hapus Akun', context, ),
              ],
              ],
            ),
          ),
        ],
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
        const SizedBox(height: 4),
        Container(
          width: MediaQuery.of(context).size.width * 0.95, // 90% of the screen width
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.brown.shade300),
          ),
          child: TextField(
            controller: TextEditingController(text: value),
            readOnly: true,
            maxLines: multiline ? null : 1,
            minLines: multiline ? 1 : null,
            decoration: null,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget buildActionButton(String text, BuildContext context) {

    VoidCallback? onPressed;

    switch (text) {
      case 'Review Saya':
        onPressed = () {
          // Add your function for 'Review Saya' here
          print('Review Saya button pressed');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        };
        break;
      case 'Bookmark Saya':
        onPressed = () {
          // Add your function for 'Bookmark Saya' here
          print('Bookmark Saya button pressed');
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        };
        break;
      case 'Resto Saya':
        onPressed = () {
          // Add your function for 'Resto Saya' here
          print('Resto Saya button pressed');
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        };
        break;
      case 'Hapus Akun':
        onPressed = () {
          // Add your function for 'Hapus Akun' here
          showDeleteDialog();
        };
        break;
      default:
        onPressed = () {
          print('$text button pressed');
        };
    }


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32), // Increase vertical and horizontal padding  
        ),
        onPressed : () {
          // Add your function for 'Review Saya' here
          Navigator.push();
        },
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}