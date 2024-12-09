import 'package:flutter/material.dart';
import 'package:uas/services/auth.dart'; // Assuming you have AuthService for login management
import 'package:uas/screens/landing/landing_page.dart';
import 'package:uas/services/landing.dart';
import 'package:uas/screens/restaurant/restaurant.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if user is logged in
  Future<void> _checkLoginStatus() async {
    final loggedIn = await _authService.isLoggedIn();
    setState(() {
      _isLoggedIn = loggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Mangan Solo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: _isLoggedIn ? _buildLoggedInContent() : _buildLoggedOutContent(),
      ),
    );
  }

  // Content for logged-in users
  Widget _buildLoggedInContent() {
    // Use the LandingPage widget for logged-in users
    return LandingPageScreen();
  }

  // Content for non-logged-in users
  Widget _buildLoggedOutContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Welcome to Mangan Solo!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const Text(
            'Please log in to continue.',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _handleLogin,
            child: const Text('Login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _handleSignUp,
            child: const Text('Sign Up'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            ),
          ),
        ],
      ),
    );
  }

  // Handle Login button press
  Future<void> _handleLogin() async {
    // Replace this with your login functionality
    Navigator.pushNamed(context, '/login'); // Navigate to your login page
  }

  // Handle Sign Up button press
  Future<void> _handleSignUp() async {
    // Replace this with your sign up functionality
    Navigator.pushNamed(context, '/signup'); // Navigate to your signup page
  }

  // Handle Logout button press
  Future<void> _handleLogout() async {
    await _authService.logout();
    setState(() {
      _isLoggedIn = false;
    });
  }
}
