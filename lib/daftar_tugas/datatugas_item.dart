import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'datatugas_list.dart';


class TugasItem extends StatelessWidget {
  final String searchQuery;

  const TugasItem({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('data_tugas')
          .orderBy('nama_tugas')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          List<DocumentSnapshot> karyawanItems = snapshot.data!.docs;
          if (searchQuery.isNotEmpty) {
            karyawanItems = karyawanItems.where((doc) {
              return doc['nama_tugas']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();
          }
          return ListView.builder(
            itemCount: karyawanItems.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = karyawanItems[index];
              return TugasListItem(document: document);
            },
          );
        }
      },
    );
  }
}
