import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas/main.dart';
import 'package:uas/screens/authentication/register.dart';
import 'package:uas/screens/landing.dart';
import 'package:uas/widgets/left_drawer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void handleLogin() async {
      setState(() {
        isLoading = true;
      });
      if (formKey.currentState!.validate()) {
        // Proceed with login logic
        final response =
            await request.login("${CONSTANTS.baseUrl}/auth/flogin/", {
          'username': _usernameController.text.trim(),
          'password': _passwordController.text.trim(),
        });
        if (request.loggedIn) {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LandingPage()),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                    content: Text(
                        "Berhasil log in. Selamat menikmati Mangan Solo!")),
              );
          }
        } else {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(CONSTANTS.licorice),
                title: const Text('LOGIN GAGAL'),
                titleTextStyle: const TextStyle(
                    color: Color(CONSTANTS.dutch),
                    fontSize: 20,
                    fontFamily: 'CrimsonPro'),
                content: Text(
                  response['message'],
                  style: const TextStyle(
                      color: Color(CONSTANTS.dutch),
                      fontSize: 16,
                      fontFamily: 'CrimsonPro'),
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(
                          color: Color(CONSTANTS.dutch),
                          fontSize: 16,
                          fontFamily: 'CrimsonPro'),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }
        }
      } else {}
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MANGAN" SOLO',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(CONSTANTS.dutch),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/batik.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Slight black mask
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: const Color(CONSTANTS.dutch),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: formKey, // Attach Form key
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon diisi dengan username...';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon diisi dengan password...';
                          } else if (value.length < 6) {
                            return 'Password diharapkan melebihi 6 karakter!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: handleLogin, // Call login handler
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(CONSTANTS.licorice),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          !isLoading ? 'Login' : 'Sedang log in...',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color(CONSTANTS.dutch),
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Belum memiliki akun?',
                            style: TextStyle(
                              color: Color(CONSTANTS.licorice),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
