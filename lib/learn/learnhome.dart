import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/learn/ask_sakhi.dart';
import 'package:sakhi/learn/financial_terms.dart';
import 'package:sakhi/learn/micro_courses.dart';
import 'package:sakhi/learn/resource.dart';
import 'package:sakhi/theme/save_theme.dart';

class LearnHomePage extends StatefulWidget {
  const LearnHomePage({super.key});

  @override
  State<LearnHomePage> createState() => _LearnHomePageState();
}

class _LearnHomePageState extends State<LearnHomePage> {
  int _selectedIndex = 0; // Current selected tab index

  // List of pages to display in the BottomNavigationBar for LEARN module
  static const List<Widget> _pages = <Widget>[
    FinancialTermsPage(),
    MicroCoursesPage(),
    AskSakhiChatbotPage(),
    ResourcesPage(),
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
        title: const Text('LEARN: Financial Empowerment'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.abc_rounded), // Financial Terms
            label: 'Terms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded), // Micro Courses
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.robot), // Ask Sakhi Chatbot
            label: 'Ask Sakhi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_shared_rounded), // Resources
            label: 'Resources',
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
