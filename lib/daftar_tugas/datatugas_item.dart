import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'datatugas_list.dart';

class TugasItem extends StatelessWidget {
  final String searchQuery;
  final String month;

  const TugasItem({required this.searchQuery, required this.month});

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
          List<DocumentSnapshot> tugasitems = snapshot.data!.docs;
          if (searchQuery.isNotEmpty) {
            tugasitems = tugasitems.where((doc) {
              return doc['nama_tugas']
                  .toString()
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();
          }
          return ListView.builder(
            itemCount: tugasitems.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = tugasitems[index];
              return TugasListItem(
                document: document,
                month: month,
              );
            },
          );
        }
      },
    );
  }
}
