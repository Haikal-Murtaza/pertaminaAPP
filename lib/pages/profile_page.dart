import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pertamina_app/nav.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _name;
  String? _employeeNumber;
  String? _profileImageUrl;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('data_karyawan')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          setState(() {
            _name = userDoc['nama_karyawan'];
            _employeeNumber = userDoc['id_karyawan'];
            _profileImageUrl = userDoc['profile_picture'];
            _userRole = userDoc['role'];
          });
        }
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            Container(height: 200, color: Color.fromARGB(255, 72, 193, 79)),
            Positioned(
              left: 16,
              bottom: 16,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : AssetImage('assets/default_profile_picture.png')
                            as ImageProvider,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name ?? 'Loading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Role : ${_userRole ?? 'Loading...'}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'No ID: ${_employeeNumber ?? 'Loading...'}',
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
          ]),
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
                // Show this menu item only if the user's role is not 'TKJP'
                if (_userRole != 'TKJP')
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings),
                    title: Text('Other Menu'),
                    onTap: () {
                      navOtherPage(context, _userRole!);
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
                  onTap: () async {
                    // Sign out the user
                    await FirebaseAuth.instance.signOut();
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
