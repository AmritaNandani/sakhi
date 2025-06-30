import 'package:flutter/material.dart';
// import 'package:sakhi/community/communityhome.dart';
// import 'package:sakhi/earn/earnhome.dart';
// import 'package:sakhi/invest/investhome.dart';
// import 'package:sakhi/learn/learnhome.dart';
// import 'package:sakhi/save/savehome.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:sakhi/screens/home.dart';
import 'package:sakhi/screens/splashscreen.dart';
import 'package:sakhi/theme/save_theme.dart';

void main() async{
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sakhi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
