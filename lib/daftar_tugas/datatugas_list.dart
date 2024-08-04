import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TugasListItem extends StatefulWidget {
  final DocumentSnapshot document;
  final String month;
  const TugasListItem({required this.document, required this.month});

  @override
  _TugasListItemState createState() => _TugasListItemState();
}

class _TugasListItemState extends State<TugasListItem> {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FixedColumnWidth(50.0),
              1: FixedColumnWidth(150.0),
              2: FixedColumnWidth(100.0),
              3: FixedColumnWidth(100.0),
              4: FixedColumnWidth(100.0),
              5: FixedColumnWidth(100.0),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[200]),
                children: [
                  TableCell(child: Center(child: Text('No'))),
                  TableCell(child: Center(child: Text('Name of Task'))),
                  TableCell(child: Center(child: Text('PIC'))),
                  TableCell(child: Center(child: Text('Frequency'))),
                  if (widget.month.isNotEmpty)
                    TableCell(child: Center(child: Text('Month'))),
                  TableCell(child: Center(child: Text('Action'))),
                ],
              ),
              TableRow(
                children: [
                  TableCell(child: Center(child: Text('1'))),
                  TableCell(
                      child: Center(
                          child: Text(widget.document['nama_tugas'],
                              style: TextStyle(fontSize: 16)))),
                  TableCell(
                      child: Center(
                          child: Text(widget.document['pic'],
                              style: TextStyle(fontSize: 16)))),
                  TableCell(
                      child: Center(
                          child: Text(widget.document['frekuensi'],
                              style:
                                  TextStyle(fontSize: 16)))),
                  if (widget.month.isNotEmpty)
                    TableCell(
                        child: Center(
                            child:
                                Text(widget.month))),
                  TableCell(
                    child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          GestureDetector(
                              onTap: () {
                                showDeleteConfirmationDialog(
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
                                          bottomRight: Radius.circular(10))),
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.white))),
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
                        ])),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, DocumentSnapshot document) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Konfirmasi"),
              content: const Text("Apakah anda ingin menghapus data ini ?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Batal")),
                TextButton(
                    onPressed: () {
                      deleteDataKaryawan(document);
                      Navigator.pop(context);
                      showDeleteSuccessNotification(context);
                    },
                    child: const Text("Hapus"))
              ]);
        });
  }

  void showDeleteSuccessNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data berhasil dihapus!"),
        backgroundColor: Color.fromARGB(255, 255, 17, 0),
        duration: Duration(seconds: 3)));
  }

  void deleteDataKaryawan(DocumentSnapshot document) async {
    try {
      await document.reference.delete();
      print("Deleted");
    } catch (e) {
      print("Error deleting: $e");
    }
  }
}
