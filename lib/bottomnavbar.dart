import 'package:flutter/material.dart';
import 'package:pertamina_app/pages/attendance_page.dart';
import 'package:pertamina_app/pages/home_page.dart';
import 'package:pertamina_app/pages/profile_page.dart';

class NavBar extends StatefulWidget {
  final String name;
  final String role;

  NavBar({required this.name, required this.role});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // list bottom bar pages
    final List<Widget> _pages = [
      HomePage(name: widget.name),
      AttendancePage(),
      ProfilePage(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Absensi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
