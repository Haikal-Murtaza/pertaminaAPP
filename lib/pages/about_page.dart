import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('App Name: Your App', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Version: 1.0.0', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Developed by: Your Company', style: TextStyle(fontSize: 18)),
            // Add more details as necessary
          ],
        ),
      ),
    );
  }
}
