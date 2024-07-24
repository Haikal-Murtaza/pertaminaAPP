import 'package:flutter/material.dart';
import 'package:pertamina_app/pages/completed_task_list_page.dart';
import 'package:pertamina_app/pages/employee_lisr_page.dart';

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
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Daftar Tugas Telah Dikerjakan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompletedTaskListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Daftar Pekerja'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployeeListPage()),
                );
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
