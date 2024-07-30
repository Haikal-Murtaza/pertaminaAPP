// ignore_for_file: file_names, library_private_types_in_public_api, use_build_context_synchronously

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

  void deleteUser(DocumentSnapshot document) {
    deleteDataKaryawan(document);
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
