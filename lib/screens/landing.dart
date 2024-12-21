import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/screens/authentication/login.dart';
import 'package:uas/screens/authentication/register.dart';
import 'package:uas/screens/landing/landing_page.dart';
import 'package:uas/widgets/footer.dart';
import 'package:uas/widgets/left_drawer.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Mangan Solo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const LeftDrawer(),
      body: const Center(child: LoginPage()),
    );
  }
}
