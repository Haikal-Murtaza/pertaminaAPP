import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StockListItem extends StatefulWidget {
  final DocumentSnapshot document;

  const StockListItem({required this.document});

  @override
  _StockListItemState createState() => _StockListItemState();
}

class _StockListItemState extends State<StockListItem> {
  late TextEditingController _quantityController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.document['jumlahstok'].toString(),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.document['namabarang'],
        style: TextStyle(fontSize: 16),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.document['jumlahstok']}',
            style: TextStyle(fontSize: 13),
          ),
          Divider(
            color: Colors.black54,
          )
        ],
      ),
    );
  }
}
