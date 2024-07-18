import 'package:flutter/material.dart';
import 'package:pertamina_app/pages/generator_page.dart';
import 'package:pertamina_app/pages/favorites_page.dart';
import 'package:pertamina_app/pages/home_page.dart';
import 'package:pertamina_app/pages/login_page.dart';
import 'package:intl/intl.dart';

// Main home page widget
class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

// State class for MyHomePage
class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  // Updates the selected tab index
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    // Handle logout logic here
    print('User logged out');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    String today = DateFormat('MMMM dd, yyyy').format(DateTime.now());
    Widget page;

    switch (_selectedIndex) {
      case 0:
        page = HomePage();
      case 1:
        page = FavoritesPage();
      case 2:
        page = GeneratorPage();
      default:
        page = HomePage(); // default to home page in case of unexpected index
    }

    return Scaffold(
      appBar: _selectedIndex != 3
          ? PreferredSize(
              preferredSize:
                  Size.fromHeight(_selectedIndex == 0 ? 160.0 : 80.0),
              child: AppBar(
                backgroundColor:
                    Colors.blue, // Set your desired background color here
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      // Row for logo and logout button
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/logo.png'), // Ensure this path is correct
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            width: 120,
                            height:
                                60, // Adjusted height to ensure it fits well
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.account_circle),
                            onPressed: () {
                              // Add your logout logic here
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      // Conditional rendering for welcome text and profile picture
                      if (_selectedIndex == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Welcome @username',
                                    style: TextStyle(fontSize: 14)),
                                Text(today, style: TextStyle(fontSize: 11)),
                              ],
                            ),
                            SizedBox(
                                width: 50), // Adjust this to control spacing
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/profile_picture.png'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              width: 80,
                              height: 100,
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            )
          : null,
      body: page,
      bottomNavigationBar: _selectedIndex != 3
          ? BottomNavigationBar(
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
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }
}
