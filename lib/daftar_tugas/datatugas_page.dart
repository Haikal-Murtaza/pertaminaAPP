import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pertamina_app/nav.dart';

class TugasListPage extends StatefulWidget {
  final String category;
  final String month;
  final DocumentSnapshot<Object?>? userData;

  TugasListPage(
      {required this.category, required this.month, required this.userData});

  @override
  State<TugasListPage> createState() => _TugasListPageState();
}

class _TugasListPageState extends State<TugasListPage> {
  late TextEditingController _searchController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
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
            child: Column(children: [
              Container(
                  height: 160,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                  child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 40, left: 20, right: 130),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/logo.png', width: 40),
                              Text('Tugas Rutin dan Non Rutin',
                                  style: TextStyle(fontSize: 17))
                            ])),
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Row(children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.keyboard_backspace_outlined,
                                  size: 35, color: Colors.black)),
                          SizedBox(width: 5),
                          Text(
                              widget.month.isEmpty
                                  ? "Kategori ${widget.category}"
                                  : "Bulan ${widget.month}",
                              style: TextStyle(fontSize: 16)),
                          Spacer()
                        ]))
                  ])),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search)),
                      onChanged: (value) {
                        _onSearchChanged();
                      })),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: (widget.month.isEmpty
                          ? FirebaseFirestore.instance
                              .collection('data_tugas')
                              .where('kategori_tugas',
                                  isEqualTo: widget.category)
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('data_tugas')
                              .where('bulanMulai', isEqualTo: widget.month)
                              .snapshots()),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final documentTasks = snapshot.data?.docs ?? [];

                        final filteredDocuments =
                            documentTasks.where((documentTask) {
                          final taskName = documentTask['nama_tugas']
                              .toString()
                              .toLowerCase();
                          return taskName.contains(searchQuery.toLowerCase());
                        }).toList();

                        if (filteredDocuments.isEmpty) {
                          return Center(child: Text('No tasks found.'));
                        }

                        return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                    columns: _createColumns(),
                                    rows: _createRows(filteredDocuments))));
                      }))
            ])),
        floatingActionButton: widget.userData?['role'] != 'TKJP'
            ? FloatingActionButton(
                onPressed: () {
                  navToAddTask(context, widget.userData?['nama_karyawan']);
                },
                tooltip: 'tambah tugas',
                child: Icon(Icons.add))
            : null);
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('No')),
      DataColumn(label: Text('Nama Tugas')),
      DataColumn(label: Text('PIC')),
      DataColumn(label: Text('Frekuensi')),
      if (widget.month.isNotEmpty) DataColumn(label: Text('Kategori')),
      DataColumn(label: Text('Status')),
      DataColumn(label: Text('Aksi'))
    ];
  }

  List<DataRow> _createRows(List<QueryDocumentSnapshot> documentTasks) {
    return documentTasks.asMap().entries.map((entry) {
      int index = entry.key;
      DocumentSnapshot documentTask = entry.value;

      return DataRow(cells: [
        DataCell(Text((index + 1).toString())),
        DataCell(Text(documentTask['nama_tugas'])),
        DataCell(Text(documentTask['pic'])),
        DataCell(Text(documentTask['frekuensi'])),
        if (widget.month.isNotEmpty)
          DataCell(Text(documentTask['kategori_tugas'])),
        DataCell(Text(documentTask['status'])),
        DataCell(
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          if (widget.userData?['role'] != 'TKJP' &&
              widget.userData?['role'] != 'Reviewer')
            GestureDetector(
                onTap: () {
                  showDeleteConfirmationDialog(context, documentTask);
                },
                child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.orange.shade700,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.delete_outline, color: Colors.white))),
          SizedBox(width: 15),
          GestureDetector(
              onTap: () {
                navToDetailsTask(context, documentTask, widget.userData);
              },
              child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: Colors.orange.shade700,
                      borderRadius: BorderRadius.circular(10)),
                  child:
                      Icon(Icons.library_books_outlined, color: Colors.white)))
        ]))
      ]);
    }).toList();
  }

  void showDeleteConfirmationDialog(
      BuildContext context, DocumentSnapshot documentTask) {
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
                      deleteDataTugas(documentTask);
                      Navigator.pop(context);
                    },
                    child: const Text("Hapus"))
              ]);
        });
  }

  void deleteDataTugas(DocumentSnapshot documentTask) async {
    try {
      var uploadDocument = documentTask['uploadDocument'];

      if (uploadDocument != null && uploadDocument['url'].isNotEmpty) {
        String fileUrl = uploadDocument['url'];

        try {
          Reference storageRef = FirebaseStorage.instance.refFromURL(fileUrl);
          await storageRef.delete();
          print("File deleted from Firebase Storage.");
        } catch (e) {
          if (e is FirebaseException && e.code == 'object-not-found') {
            print(
                "File not found in Firebase Storage, proceeding with deletion.");
          } else {
            print("Error deleting file from Firebase Storage: $e");
            rethrow;
          }
        }
      }

      await documentTask.reference.delete();
      print("Document ${documentTask.id} deleted from Firestore.");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data berhasil dihapus!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3)));
    } catch (e) {
      print("Error deleting: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error occurred during deletion: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3)));
    }
  }
}
