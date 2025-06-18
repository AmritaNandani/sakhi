import 'package:flutter/material.dart';
import 'package:sakhi/community/discovery_circles_screen.dart';
import 'package:sakhi/community/events_screen.dart';
import 'package:sakhi/community/feed_screen.dart';
import 'package:sakhi/community/profile_screen.dart';
import 'package:sakhi/community/resources_screen.dart'; // Still needed for currentUser in FAB logic, etc.

// This class now acts as the root for your community section, applying its specific theme.
class CommunityHomePage extends StatefulWidget {
  const CommunityHomePage({super.key});

  @override
  State<CommunityHomePage> createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  int _selectedIndex = 0;

  // List of screens to display in the BottomNavigationBar
  static final List<Widget> _widgetOptions = <Widget>[
    const FeedScreen(),
    const DiscoveryCirclesScreen(),
    const EventsScreen(),
    const ResourcesScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The Scaffold here provides the single AppBar and BottomNavigationBar for the community section
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harmony Haven'), // Title applied from AppBarTheme in app_theme.dart
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search), // Colors inherited from AppBarTheme
            onPressed: () {
              // Handle search
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none), // Colors inherited from AppBarTheme
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex), // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            activeIcon: Icon(Icons.groups),
            label: 'Circles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            activeIcon: Icon(Icons.event_note),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            activeIcon: Icon(Icons.lightbulb),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // Floating Action Button logic remains for the Feed screen
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Handle new post creation
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
