import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Restoran'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
          child: SizedBox(
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.brown, width: 7.5),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ), // Rounded corners for the image
                  child: Image.network(
                    'https://placehold.co/600x400/png', // Fallback image
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                ElevatedButton(
                    onPressed: onPressed, child: Text('Tambahkan ke Bookmark')),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Restoran',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                ),
              ],
            )),
      )),
    );
  }
}
