import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'datakaryawan_listitem.dart';

class KaryawanItem extends StatelessWidget {
  final String searchQuery;

  const KaryawanItem({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('data_karyawan')
            .orderBy('nama_karyawan')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<DocumentSnapshot> karyawanItems = snapshot.data!.docs;
            if (searchQuery.isNotEmpty) {
              karyawanItems = karyawanItems.where((doc) {
                return doc['nama_karyawan']
                    .toString()
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
              }).toList();
            }
            return ListView.builder(
                itemCount: karyawanItems.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = karyawanItems[index];
                  return KaryawanListItem(document: document);
                });
          }
        });
  }
}
