// lib/home_page.dart

import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/save/goal_setting_page.dart';
import 'package:sakhi/save/progress_tracker_page.dart';
import 'package:sakhi/save/savings_plan_page.dart';
import 'package:sakhi/save/settings_page.dart';

class SaveHomePage extends StatefulWidget {
  const SaveHomePage({super.key});

  @override
  State<SaveHomePage> createState() => _SaveHomePageState();
}

class _SaveHomePageState extends State<SaveHomePage> {
  int _selectedIndex = 0; // Current selected tab index

  // List of pages to display in the BottomNavigationBar
  static const List<Widget> _pages = <Widget>[
    GoalSettingPage(),
    SavingsPlanPage(),
    ProgressTrackerPage(),
    // SettingsPage(),
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
        title: const Text('SAVE: Savings for Her'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline_rounded),
            label: 'Plan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_rounded),
            label: 'Progress',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings_rounded),
          //   label: 'Settings',
          // ),
        ],
        currentIndex: _selectedIndex, // Set the current selected index
        onTap: _onItemTapped, // Callback when a tab is tapped
      ),
    );
  }
}
