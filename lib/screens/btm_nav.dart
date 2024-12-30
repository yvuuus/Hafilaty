import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'schedule_screen.dart';
import 'profile_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // To track the selected tab

  // List of widgets (pages) to display on each tab
  final List<Widget> _pages = [
    MapScreen(),
    ScheduleScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 237, 161, 251), // Purple background for the nav bar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: GNav(
            gap: 8,
            backgroundColor: const Color.fromARGB(255, 237, 161, 251),
            color: Colors.white, // Icon and text color for unselected tabs
            activeColor: Colors.white, // Icon and text color for selected tab
            tabBackgroundColor: const Color.fromARGB(255, 207, 118, 245), // Background color for the selected tab
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            selectedIndex: _currentIndex, // Current selected index
            onTabChange: (index) {
              setState(() {
                _currentIndex = index; // Update selected tab
              });
            },
            tabs: const [
              GButton(
                icon: Icons.map,
                text: 'Map',
              ),
              GButton(
                icon: Icons.schedule,
                text: 'Schedule',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
