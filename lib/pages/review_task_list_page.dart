import 'package:flutter/material.dart';

class ReviewTaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar tugas menunggu review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(title: Text('Task 1')),
            ListTile(title: Text('Task 2')),
            ListTile(title: Text('Task 3')),
            // Add more completed task list items here
          ],
        ),
      ),
    );
  }
}
