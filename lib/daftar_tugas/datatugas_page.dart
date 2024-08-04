import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pertamina_app/nav.dart';

class TugasListPage extends StatefulWidget {
  final String category;
  final int tasks;
  final String month;

  TugasListPage({required this.category, required this.tasks, this.month = ''});

  @override
  State<TugasListPage> createState() => _TaskListPage();
}

class _TaskListPage extends State<TugasListPage> {
  late TextEditingController _searchController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: deviceHeight,
        width: deviceWidth,
        child: Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/logo.png', width: 150),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 20, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.keyboard_backspace_outlined,
                            size: 35,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Tugas Rutin dan Non Rutin ${widget.month.isEmpty ? widget.category : "bulan ${widget.month}"}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  _onSearchChanged();
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('data_tugas')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final filteredDocuments =
                      snapshot.data!.docs.where((document) {
                    final taskName =
                        document['nama_tugas'].toString().toLowerCase();
                    return taskName.contains(searchQuery.toLowerCase());
                  }).toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: _createColumns(),
                        rows: _createRows(filteredDocuments),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navToAddTask(context);
        },
        tooltip: 'tambah tugas',
        child: Icon(Icons.add),
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('No')),
      DataColumn(label: Text('Nama Tugas')),
      DataColumn(label: Text('PIC')),
      DataColumn(label: Text('Frekuensi')),
      if (widget.month.isNotEmpty) DataColumn(label: Text('Ketegori')),
      DataColumn(label: Text('Aksi')),
    ];
  }

  List<DataRow> _createRows(List<QueryDocumentSnapshot> documents) {
    return documents.asMap().entries.map((entry) {
      int index = entry.key;
      DocumentSnapshot document = entry.value;

      return DataRow(cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(document['nama_tugas'])),
        DataCell(Text(document['pic'])),
        DataCell(Text(document['frekuensi'])),
        if (widget.month.isNotEmpty) DataCell(Text(document['kategori_tugas'])),
        DataCell(Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                showDeleteConfirmationDialog(context, document);
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.delete_outline, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () {
                navToDetailsTask(context, document);
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.library_books_outlined, color: Colors.white),
              ),
            ),
          ],
        )),
      ]);
    }).toList();
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
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                deleteDataKaryawan(document);
                Navigator.pop(context);
                showDeleteSuccessNotification(context);
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  void showDeleteSuccessNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Data berhasil dihapus!"),
      backgroundColor: Color.fromARGB(255, 255, 17, 0),
      duration: Duration(seconds: 3),
    ));
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
