// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'authDataKaryawan.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      height: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(255, 217, 217, 217)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.document['nama_karyawan'],
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  widget.document['nip_karyawan'],
                  style: TextStyle(fontSize: 16),
                ),
                Text(widget.document['jabatan_karyawan'],
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Container(
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDeleteConfirmationDialog;
                        },
                        child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.orange.shade700,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: Icon(Icons.delete_outline,
                                color: Colors.white)),
                      ),
                      Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Icon(Icons.edit_square, color: Colors.white)),
                      Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              color: Colors.orange.shade700,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Icon(Icons.library_books_outlined,
                              color: Colors.white))
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 15),
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.green),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/profile_picture.png',
                      fit: BoxFit.fitHeight, height: 90, width: 160)))
        ],
      ),
    );
  }
}
