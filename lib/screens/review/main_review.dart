import 'package:flutter/material.dart';
import 'package:uas/screens/review/create_form.dart';
import 'package:uas/screens/review/edit_form.dart';
import 'package:uas/models/review.dart';

class ReviewPage extends StatelessWidget {
  ReviewPage({super.key});

  final List<Map<String, String>> reviews = [
    {
      "name": "Nama Restoran",
      "title": "Judul Review",
      "author": "Delya",
      "rating": "5/5",
      "comment": "Bagus Banget!",
      "date": "26 November 2024",
      "image": "assets/warung_example.jpg",
      "likes": "100"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Mangan" Solo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            WriteReviewButton(),
            const SizedBox(height: 16),
            const SortButtons(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return ReviewCard(
                    name: review["name"]!,
                    title: review["title"]!,
                    author: review["author"]!,
                    rating: review["rating"]!,
                    comment: review["comment"]!,
                    date: review["date"]!,
                    image: review["image"]!,
                    likes: review["likes"]!,
                    onEdit: () {
                      // Open the EditReviewDialog when the "Edit" button is pressed
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return EditReviewDialog(
                            initialTitle: review["title"]!,
                            initialRating: review["rating"]!,
                            initialReview: review["comment"]!,
                            initialDisplayName: review["author"]!,
                            onSave: (String title, String rating, String reviewText) {
                              // Handle the save logic here (e.g., send the data to the backend)
                              print('Saved Review: Title=$title, Rating=$rating, Review=$reviewText');
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WriteReviewButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.brown[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Review",
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
          const Text(
            "Bagikan Pengalaman Anda dengan Restoran Kami Melalui Ulasan!",
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
          ElevatedButton(
            onPressed: () {
              // Navigate to CreateReviewPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReviewFormPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Tulis Review'),
          ),
        ],
      ),
    );
  }
}

class SortButtons extends StatelessWidget {
  const SortButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Sort by Like'),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Sort by Date'),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Sort by Rate'),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name;
  final String title;
  final String author;
  final String rating;
  final String comment;
  final String date;
  final String image;
  final String likes;
  final VoidCallback onEdit;

  const ReviewCard({
    super.key,
    required this.name,
    required this.title,
    required this.author,
    required this.rating,
    required this.comment,
    required this.date,
    required this.image,
    required this.likes,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text("Judul Review: $title"),
            Text("Penulis: $author"),
            const SizedBox(height: 8.0),
            Text("Rating: $rating"),
            Text("Comment: $comment"),
            Text("Tanggal: $date"),
            const SizedBox(height: 8.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(image),
            ),
            const SizedBox(height: 8.0),
            Text("Like: $likes"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: onEdit,
                    child: const Text("Edit"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

