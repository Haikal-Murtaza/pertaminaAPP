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
                title: Text('Daftar Tugas Completed'),
              ),
            ),
            GestureDetector(
              onTap: () {
                navApproveTaskPage(context);
              },
              child: ListTile(
                leading: Icon(Icons.approval),
                title: Text('Daftar Tugas Menunggu Approval'),
              ),
            ),
            GestureDetector(
              onTap: () {
                navReviewTaskPage(context);
              },
              child: ListTile(
                leading: Icon(Icons.reviews),
                title: Text('Daftar Tugas Menunggu Review'),
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
