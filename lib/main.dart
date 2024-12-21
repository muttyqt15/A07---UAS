import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/screens/landing.dart';

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
            primarySwatch: _createMaterialColor(const Color(CONSTANTS.coyote)),
          ).copyWith(secondary: const Color(CONSTANTS.lion)),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: const Color(CONSTANTS.licorice),
            contentTextStyle: const TextStyle(
              color: Color(CONSTANTS.dutch),
              fontSize: 16,
            ),
            actionTextColor: const Color(CONSTANTS.dutch),
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

  // Helper function to create MaterialColor from HEX
  MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[
      0.05,
      0.1,
      0.2,
      0.3,
      0.4,
      0.5,
      0.6,
      0.7,
      0.8,
      0.9
    ];
    Map<int, Color> swatch = {};
    for (var strength in strengths) {
      final int r = (color.red * (1 - strength)).round();
      final int g = (color.green * (1 - strength)).round();
      final int b = (color.blue * (1 - strength)).round();
      swatch[(strength * 1000).round()] = Color.fromRGBO(r, g, b, 1);
    }
    return MaterialColor(color.value, swatch);
  }
}

class CONSTANTS {
  static const String baseUrl = "http://10.0.2.2:8000";

  // Colors
  static const int licorice = 0xFF240F0E;
  static const int coyote = 0xFF7D6E5F;
  static const int lion = 0xFFC1A386;
  static const int dutch = 0xFFE5D2B0;
  static const int raisin = 0xFF262A37;
}
