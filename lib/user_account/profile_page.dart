import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pertamina_app/nav.dart';

class ProfilePage extends StatefulWidget {
  final DocumentSnapshot userData;

  const ProfilePage({required this.userData});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Stack(children: [
        Container(height: 200, color: Color.fromARGB(255, 72, 193, 79)),
        Positioned(
            left: 16,
            bottom: 16,
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: widget.userData['profile_picture'] != null
                    ? NetworkImage(widget.userData['profile_picture']!)
                    : AssetImage('assets/default_profile_picture.png')
                        as ImageProvider,
              ),
              SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.userData['nama_karyawan'] ?? 'Loading...',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text('Role : ${widget.userData['role'] ?? 'Loading...'}',
                    style: TextStyle(color: Colors.white70, fontSize: 16)),
                Text('No ID: ${widget.userData['id_karyawan'] ?? 'Loading...'}',
                    style: TextStyle(color: Colors.white70, fontSize: 16))
              ])
            ]))
      ]),
      Expanded(
          child: ListView(children: [
        ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              navNotificationPage(
                  context, widget.userData['role'], widget.userData.id);
            }),
        if (widget.userData['role'] != 'TKJP' &&
            widget.userData['role'] != null)
          ListTile(
              leading: Icon(Icons.admin_panel_settings),
              title: Text('Other Menu'),
              onTap: () {
                navOtherPage(context, widget.userData);
              }),
        ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy'),
            onTap: () {
              navPrivacyPage(context);
            }),
        ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              navAboutPage(context);
            }),
        Divider(),
        ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              navLogout(context);
            })
      ]))
    ]));
  }
}
