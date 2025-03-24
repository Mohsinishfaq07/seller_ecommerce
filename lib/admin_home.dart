import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0; // Current selected tab index
  final List<Widget> _pages = [
    // Home page
    const Center(
      child: Text(
        'Welcome to Admin Dashboard!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
    // User management page
    const Center(
      child: Text(
        'Manage Users',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    // Reports page
    const Center(
      child: Text(
        'View Reports',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    // Messages page
    const Center(
      child: Text(
        'Messages',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    // Settings page
    const Center(
      child: Text(
        'Settings',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  ];

  /// Handles bottom navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(color: Colors.teal),
          ),
          backgroundColor: Colors.white,
          elevation: 2.0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.teal),
        ),
        body: _pages[_selectedIndex], // Display the current page
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Currently selected tab
          onTap: _onItemTapped, // Handle tab selection
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: 'Reports'),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: 'Messages'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
          ],
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
