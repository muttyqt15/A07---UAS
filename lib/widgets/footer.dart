import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[800],
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "© 2024 Mangan Solo. All rights reserved.",
            style: TextStyle(
              color: Colors.white70,
              fontFamily: "Lora",
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
