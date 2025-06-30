// lib/home_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/earn/community_page.dart';
import 'package:sakhi/earn/income_tracker_page.dart';
import 'package:sakhi/earn/learning_modules_page.dart';
import 'package:sakhi/earn/skill_matching_page.dart';
import 'package:sakhi/theme/save_theme.dart';

class EarnHomePage extends StatefulWidget {
  const EarnHomePage({super.key});

  @override
  State<EarnHomePage> createState() => _EarnHomePageState();
}

class _EarnHomePageState extends State<EarnHomePage> {
  int _selectedIndex = 0; // Current selected tab index

  // List of pages to display in the BottomNavigationBar for EARN module
  static const List<Widget> _pages = <Widget>[
    SkillMatchingPage(),
    // LearningModulesPage(),
    CommunityPage(),
    IncomeTrackerPage(),
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EARN: Convert Skills to Income'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.lightbulb), // Skill Matching
            label: 'Ideas',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.school_rounded), // Learning Modules
          //   label: 'Learn',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_rounded), // Community
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartLine), // Income Tracker
            label: 'Income',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey[600],
      ),
    );
  }
}
