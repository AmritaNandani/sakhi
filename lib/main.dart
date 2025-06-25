import 'package:flutter/material.dart';
import 'package:sakhi/community/communityhome.dart';
import 'package:sakhi/save/savehome.dart';
import 'package:sakhi/theme/app_theme.dart';

void main() {
  runApp(const CommunityApp());
}

// --- Main Application Widget ---

class CommunityApp extends StatelessWidget {
  const CommunityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Harmony Haven',
      debugShowCheckedModeBanner: false,
      // Apply the custom community theme here
      home: Theme(
        data: AppTheme.communityTheme,
        child: const HomePage(),
      ),
    );
  }
}
