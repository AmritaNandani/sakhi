// lib/home_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sakhi/community/communityhome.dart';

// --- Placeholder imports for your pre-made pages ---
import 'package:sakhi/earn/earnhome.dart';
import 'package:sakhi/invest/investhome.dart';
import 'package:sakhi/learn/ask_sakhi.dart';
import 'package:sakhi/learn/learnhome.dart';
import 'package:sakhi/save/savehome.dart';
import 'package:sakhi/theme/save_theme.dart'; // Assuming AppTheme is defined here
import '../navbar/about.dart';
import 'package:sakhi/screens/profile.dart';
import 'package:sakhi/screens/calculation.dart';
// ----------------------------------------------------

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Current selected tab in bottom navigation

  static final List<Widget> _bottomNavPages = <Widget>[
    _HomeDashboardContent(), // Our new sleek dashboard
    const CalculationsPage(),
    const CommunityHomePage(),
    const AskSakhiChatbotPage(),
    const AboutPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool get _showAppBar {
    // Hide AppBar for Calculator (1), Community (2), and Ask Sakhi (3)
    return !(_selectedIndex == 1 || _selectedIndex == 2 || _selectedIndex == 3);
  }

  bool get _showBottomNavBar {
    // Hide BottomNavBar for Community (2)
    return _selectedIndex != 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows body to go behind AppBar for custom effects
      appBar: _showAppBar
          ? AppBar(
              backgroundColor: Colors.transparent, // Make AppBar transparent
              elevation: 0, // Remove shadow
              title: Text(
                'Sakhi',
                style: TextStyle(
                  color: AppTheme.primaryColor, // Use primary color for title
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.person_rounded, color: AppTheme.primaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
              ],
            )
          : null,
      body: _bottomNavPages[_selectedIndex],
      bottomNavigationBar: _showBottomNavBar
          ? BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.calculator),
                  label: 'Calc',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt_rounded),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.robot),
                  label: 'Sakhi',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info_outline_rounded),
                  label: 'About',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: Colors.grey[600],
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppTheme.cardColor, // A slightly different background for nav bar
              elevation: 8,
            )
          : null,
    );
  }
}

class _HomeDashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // A subtle background gradient for the entire page
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            AppTheme.primaryColor.withOpacity(0.05),
            // Lightest shade to complement your theme
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adds space for the transparent AppBar
            SizedBox(height: MediaQuery.of(context).padding.top + AppBar().preferredSize.height * 0.5),

            Text(
              'Your Financial Journey',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Navigate your path to financial independence.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
            ),
            const SizedBox(height: 30),

            // Feature Grid - Redesigned for a sleek look
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              childAspectRatio: 0.9, // Slightly adjust aspect ratio to accommodate slogan
              children: [
                _buildSleekFeatureItem(
                  context,
                  title: 'LEARN',
                  subtitle: 'Teach Her, Train Her, Empower Her', // Slogan added
                  icon: Icons.school_rounded,
                  gradientColors: [Colors.teal.shade300, Colors.teal.shade600],
                  page: const LearnHomePage(),
                ),
                _buildSleekFeatureItem(
                  context,
                  title: 'INVEST',
                  subtitle: 'Make Her Money Work for Her', // Slogan added
                  icon: Icons.trending_up_rounded,
                  gradientColors: [Colors.orange.shade300, Colors.orange.shade600],
                  page: const InvestHomePage(),
                ),
                _buildSleekFeatureItem(
                  context,
                  title: 'SAVE',
                  subtitle: 'Build Her Habit of Savings', // Slogan added
                  icon: Icons.savings_rounded,
                  gradientColors: [Colors.blue.shade300, Colors.blue.shade600],
                  page: const SaveHomePage(),
                ),
                _buildSleekFeatureItem(
                  context,
                  title: 'EARN',
                  subtitle: 'Convert Her Skills to Income', // Slogan added
                  icon: FontAwesomeIcons.briefcase,
                  gradientColors: [Colors.purple.shade300, Colors.purple.shade600],
                  page: const EarnHomePage(),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Quick Actions - Horizontal Scroll
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 120, // Define a fixed height for horizontal scroll
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildQuickActionPill(
                    context,
                    label: 'Set New Savings Goal',
                    icon: Icons.star_rounded,
                    onPressed: () {
                      _showSnackBar(context, 'Navigating to Set New Savings Goal...');
                    },
                  ),
                  const SizedBox(width: 15),
                  _buildQuickActionPill(
                    context,
                    label: 'Find Income Ideas',
                    icon: FontAwesomeIcons.lightbulb,
                    onPressed: () {
                      _showSnackBar(context, 'Navigating to Find Income Ideas...');
                    },
                  ),
                  const SizedBox(width: 15),
                  _buildQuickActionPill(
                    context,
                    label: 'View Investment Portfolio',
                    icon: Icons.pie_chart_rounded,
                    onPressed: () {
                      _showSnackBar(context, 'Viewing Investment Portfolio...');
                    },
                  ),
                  const SizedBox(width: 15),
                  _buildQuickActionPill(
                    context,
                    label: 'Explore Learning Modules',
                    icon: Icons.menu_book_rounded,
                    onPressed: () {
                      _showSnackBar(context, 'Exploring Learning Modules...');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Center(
              child: Text(
                'Empowering every woman for a financially secure future.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- New Sleek Feature Item Widget with Subtitle ---
  Widget _buildSleekFeatureItem(
    BuildContext context, {
    required String title,
    required String subtitle, // Subtitle parameter added
    required IconData icon,
    required List<Color> gradientColors,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Added padding for content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
            children: [
              Align(
                alignment: Alignment.center, // Center the icon
                child: Icon(icon, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 15),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4), // Space between title and subtitle
              Text(
                subtitle, // Display the slogan
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- New Quick Action Pill Widget ---
  Widget _buildQuickActionPill(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 160, // Fixed width for each pill
      decoration: BoxDecoration(
        color: AppTheme.cardColor, // White or light background
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material( // Material widget for InkWell splash effect
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: AppTheme.primaryColor),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper for showing snackbar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
}