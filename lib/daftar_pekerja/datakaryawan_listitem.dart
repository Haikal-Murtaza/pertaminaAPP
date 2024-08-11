// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pertamina_app/nav.dart';

class KaryawanListItem extends StatefulWidget {
  final DocumentSnapshot document;
  const KaryawanListItem({required this.document});

  @override
  _KaryawanListItemState createState() => _KaryawanListItemState();
}

class _KaryawanListItemState extends State<KaryawanListItem> {
  // User? _currentUser;

  @override
  void initState() {
    super.initState();
    // _currentUser = FirebaseAuth.instance.currentUser;
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
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nama : " + widget.document['nama_karyawan'],
                        style: TextStyle(fontSize: 16)),
                    Text("No ID : " + widget.document['id_karyawan'],
                        style: TextStyle(fontSize: 16)),
                    Text("Role : " + widget.document['role'],
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    SizedBox(
                        width: 120,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    navToDetailsKaryawan(
                                        context, widget.document);
                                  },
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.orange.shade700,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: Icon(Icons.edit_square,
                                          color: Colors.white))),
                              SizedBox(width: 10),
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
                            ]))
                  ])),
          Container(
              margin: EdgeInsets.only(right: 15),
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.green),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.document['profile_picture'] != null
                      ? Image.network(widget.document['profile_picture'],
                          fit: BoxFit.cover, height: 130, width: 130)
                      : Image.asset('assets/default_profile_picture.png',
                          fit: BoxFit.cover, height: 130, width: 130)))
        ]));
  }
}
