import 'package:flutter/material.dart';
import '../nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtherPage extends StatefulWidget {
  final String userRole;

  const OtherPage({required this.userRole});

  @override
  _OtherPageState createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Other Page')),
        body: ListView(children: [
          GestureDetector(
              onTap: () {
                navCompletedTaskPage(context);
              },
              child: ListTile(
                  leading: Icon(Icons.task),
                  title: Text('Daftar Tugas Completed'))),
          GestureDetector(
              onTap: () {
                navApproveTaskPage(context);
              },
              child: ListTile(
                  leading: Icon(Icons.approval),
                  title: Text('Daftar Tugas Menunggu Approval'))),
          if (widget.userRole == 'Reviewer' || widget.userRole == 'Admin')
            GestureDetector(
                onTap: () {
                  navReviewTaskPage(context);
                },
                child: ListTile(
                    leading: Icon(Icons.reviews),
                    title: Text('Daftar Tugas Menunggu Review'))),
          if (widget.userRole == 'Admin')
            GestureDetector(
                onTap: () {
                  navEmployeePage(context);
                },
                child: ListTile(
                    leading: Icon(Icons.group), title: Text('Daftar Pekerja'))),
          Divider()
        ]));
  }
}
