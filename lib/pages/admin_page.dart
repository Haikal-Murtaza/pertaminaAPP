import 'package:flutter/material.dart';
import '../nav.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrator Page'),
      ),
      body: Expanded(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                navCompletedTaskPage(context);
              },
              child: ListTile(
                leading: Icon(Icons.task),
                title: Text('Daftar Tugas Telah Dikerjakan'),
              ),
            ),
            GestureDetector(
              onTap: () {
                navEmployeePage(context);
              },
              child: ListTile(
                leading: Icon(Icons.group),
                title: Text('Daftar Pekerja'),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
