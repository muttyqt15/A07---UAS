import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
      body: Container(
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
                backgroundColor: Colors.grey.shade300,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Adel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
              ),
              Text(
                'Customer',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.brown.shade600,
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
                    buildTextField(
                      label: 'Email',
                      value: 'myemail@email.com',
                    ),
                    const SizedBox(height: 20),
                    buildTextField(
                      label: 'Email',
                      value: 'myemail@email.com',
                      multiline: true,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Colors.brown, width: 1.5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
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
              const SizedBox(height: 20),
              Container(
                color: Colors.brown.shade800,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'MANGAN" SOLO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '"Kuliner Solo, perpaduan sempurna antara budaya, rasa, dan cinta yang selalu bikin rindu"',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Restoran',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Thread',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Berita',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Bookmark',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '© 2024 MANGAN"SOLO. All rights reserved.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
