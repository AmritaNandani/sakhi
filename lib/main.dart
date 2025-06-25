import 'package:flutter/material.dart';
// import 'package:sakhi/community/communityhome.dart';
// import 'package:sakhi/earn/earnhome.dart';
// import 'package:sakhi/invest/investhome.dart';
// import 'package:sakhi/learn/learnhome.dart';
// import 'package:sakhi/save/savehome.dart';
import 'package:sakhi/screens/home.dart';
import 'package:sakhi/theme/save_theme.dart';

void main() {
  runApp(const MyApp());
}

// --- Main Application Widget ---

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakhi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Use your main theme here
      home: const HomePage(),
    );
  }
}
