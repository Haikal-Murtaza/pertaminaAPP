import 'package:flutter/material.dart';
import 'package:pertamina_app/nav.dart';

class ProfilePage extends StatelessWidget {
  final String name = 'Haikal Murtaza';
  final String employeeNumber = '2021573010031';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                color: Color.fromARGB(255, 72, 193, 79),
              ),
              Positioned(
                left: 16,
                bottom: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/default_profile_picture.png')),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'No ID: $employeeNumber',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notifications'),
                  onTap: () {
                    navNotificationPage(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Admin Menu'),
                  onTap: () {
                    navAdminPage(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Privacy'),
                  onTap: () {
                    navPrivacyPage(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  onTap: () {
                    navAboutPage(context);
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    navLogout(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
