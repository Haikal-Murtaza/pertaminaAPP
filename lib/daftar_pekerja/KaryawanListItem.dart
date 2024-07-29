// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KaryawanListItem extends StatefulWidget {
  final DocumentSnapshot document;

  const KaryawanListItem({required this.document});

  @override
  _KaryawanListItemState createState() => _KaryawanListItemState();
}

class _KaryawanListItemState extends State<KaryawanListItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 25),
      height: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 217, 217, 217)),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              children: [
                Text(
                  widget.document['nama_karyawan'],
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  widget.document['nama_karyawan'],
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          )
        ],
      ),
    );
    // return Container(
    //   title: Text(
    //     widget.document['nama_karyawan'],
    //     style: TextStyle(fontSize: 16),
    //   ),
    //   subtitle: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         '${widget.document['email_karyawan']}',
    //         style: TextStyle(fontSize: 13),
    //       ),
    //       Divider(
    //         color: Colors.black54,
    //       )
    //     ],
    //   ),
    // );
  }
}
