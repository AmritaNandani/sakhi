// lib/home_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/invest/investment_calculator.dart';
import 'package:sakhi/invest/investment_recommendation_page.dart';
import 'package:sakhi/invest/scheme_explorer.dart';
import 'package:sakhi/theme/save_theme.dart';

class InvestHomePage extends StatefulWidget {
  const InvestHomePage({super.key});

  @override
  State<InvestHomePage> createState() => _InvestHomePageState();
}

class _InvestHomePageState extends State<InvestHomePage> {
  int _selectedIndex = 0; // Current selected tab index

  // List of pages to display in the BottomNavigationBar for INVEST module
  static final List<Widget> _pages = <Widget>[
    const InvestmentRecommendationPage(),
    SchemeExplorerPage(),
    const InvestmentCalculatorPage(),
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
        title: const Text('INVEST: Make Money Work for You'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend_rounded), // Recommendations
            label: 'Recommend',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded), // Scheme Explorer
            label: 'Schemes',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calculator), // Investment Calculator
            label: 'Calculator',
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
