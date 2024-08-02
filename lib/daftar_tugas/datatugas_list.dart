import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TugasListItem extends StatefulWidget {
  final DocumentSnapshot document;
  const TugasListItem({required this.document});

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
                    Text(
                      widget.document['nama_tugas'],
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      widget.document['pic'],
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(widget.document['deskripsi'],
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    SizedBox(
                        width: 120,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              bottomRight:
                                                  Radius.circular(10))),
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
                                  child: Icon(Icons.edit_square,
                                      color: Colors.white)),
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
        ]));
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

// body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Table(
//               border: TableBorder
//                   .all(), // Add this to get lines between rows and columns
//               columnWidths: const {
//                 0: FixedColumnWidth(50.0),
//                 1: FixedColumnWidth(150.0),
//                 2: FixedColumnWidth(100.0),
//                 3: FixedColumnWidth(100.0),
//                 4: FixedColumnWidth(100.0),
//                 5: FixedColumnWidth(100.0),
//               },
//               children: [
//                 TableRow(
//                   decoration: BoxDecoration(color: Colors.grey[200]),
//                   children: [
//                     TableCell(child: Center(child: Text('No'))),
//                     TableCell(child: Center(child: Text('Name of Task'))),
//                     TableCell(child: Center(child: Text('PIC'))),
//                     TableCell(child: Center(child: Text('Frequency'))),
//                     if (month.isNotEmpty)
//                       TableCell(child: Center(child: Text('Month'))),
//                     TableCell(child: Center(child: Text('Action'))),
//                   ],
//                 ),
//                 ...List<TableRow>.generate(
//                   tasks,
//                   (index) => TableRow(
//                     children: [
//                       TableCell(
//                           child: Center(child: Text((index + 1).toString()))),
//                       TableCell(
//                           child: Center(child: Text('Task ${index + 1}'))),
//                       TableCell(
//                           child: Center(
//                               child: Text('Person ${index + 1}'))), // Dummy PIC
//                       TableCell(
//                           child:
//                               Center(child: Text('Daily'))), // Dummy frequency
//                       if (month.isNotEmpty)
//                         TableCell(
//                             child: Center(child: Text(month))), // Dummy month
//                       TableCell(
//                         child: Center(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Action button logic
//                             },
//                             child: Text('Action'),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );