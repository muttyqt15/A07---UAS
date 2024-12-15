import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/screens/landing.dart';
import 'package:uas/widgets/left_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Mental Health Tracker',
        theme: ThemeData(
          fontFamily: 'CrimsonPro',
          fontFamilyFallback: const ['Lora', 'CrimsonPro', 'CrimsonText'],
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.deepPurple[400]),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.deepPurple[400],
            contentTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            actionTextColor: Colors.amber,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        home: LandingPage(),
      ),
    );
  }
}
