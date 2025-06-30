import 'package:flutter/material.dart';
import 'package:sakhi/screens/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFE98AD), // ✅ Your exact pink
      body: Center(
        child: Image.asset(
          'assets/images/sakhi_logo.png',
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
    );
  }
}
