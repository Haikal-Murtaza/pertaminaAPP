import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pertamina_app/daftar_tugas/uploaded_docs_task_page.dart';
import 'package:pertamina_app/nav.dart';

class ReviewTaskListPage extends StatefulWidget {
  @override
  State<ReviewTaskListPage> createState() => _ReviewTaskListPageState();
}

class _ReviewTaskListPageState extends State<ReviewTaskListPage> {
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
                              Image.asset('assets/logo.png', width: 40)
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
                          Text('Tugas membutuhkan review',
                              style: TextStyle(fontSize: 17)),
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
                      stream: FirebaseFirestore.instance
                          .collection('data_tugas')
                          .where('status', whereIn: [
                        'Pending',
                        'Ask to Revise'
                      ]).snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
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
            ])));
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('No')),
      DataColumn(label: Text('Nama Tugas')),
      DataColumn(label: Text('PIC')),
      DataColumn(label: Text('Frekuensi')),
      DataColumn(label: Text('Kategori')),
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
        DataCell(Text(documentTask['kategori_tugas'])),
        DataCell(Text(documentTask['status'])),
        DataCell(
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GestureDetector(
              onTap: () {
                navToDoc(context, documentTask, 1);
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
}
