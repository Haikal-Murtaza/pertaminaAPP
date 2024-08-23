import 'package:flutter/material.dart';
import '../nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OtherPage extends StatefulWidget {
  final DocumentSnapshot userData;

  const OtherPage({required this.userData});

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
        appBar: AppBar(title: Text('Other Menu')),
        body: ListView(children: [
          GestureDetector(
              onTap: () {
                navCompletedTaskPage(context);
              },
              child: ListTile(
                  leading: Icon(Icons.task),
                  title: Text('Daftar Tugas Completed'))),
          if (widget.userData['role'] == 'Approver' ||
              widget.userData['role'] == 'Admin')
            GestureDetector(
                onTap: () {
                  navApproveTaskPage(context);
                },
                child: ListTile(
                    leading: Icon(Icons.approval),
                    title: Text('Daftar Tugas Menunggu Approval'))),
          if (widget.userData['role'] == 'Reviewer' ||
              widget.userData['role'] == 'Admin')
            GestureDetector(
                onTap: () {
                  navReviewTaskPage(context);
                },
                child: ListTile(
                    leading: Icon(Icons.reviews),
                    title: Text('Daftar Tugas Menunggu Review'))),
          if (widget.userData['role'] == 'Reviewer' ||
              widget.userData['role'] == 'Admin')
            GestureDetector(
                onTap: () {
                  navEmployeePage(context, widget.userData);
                },
                child: ListTile(
                    leading: Icon(Icons.group), title: Text('Daftar Pekerja'))),
          if (widget.userData['role'] == 'Reviewer' ||
              widget.userData['role'] == 'Admin')
            GestureDetector(
                onTap: () {
                  navGenQR(context);
                },
                child: ListTile(
                    leading: Icon(Icons.qr_code),
                    title: Text('Generate Absensi'))),
          Divider()
        ]));
  }
}
