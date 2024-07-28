import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListEmployee extends StatefulWidget {
  final DocumentSnapshot document;

  const ListEmployee({required this.document});

  @override
  _ListEmployeeState createState() => _ListEmployeeState();
}

class _ListEmployeeState extends State<ListEmployee> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.document['n'],
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'Stock: ${widget.document['jumlahstok']}',
          //   style: TextStyle(fontSize: 13),
          // ),
          Divider(
            color: Colors.black54,
          )
        ],
      ),
    );
  }
}
