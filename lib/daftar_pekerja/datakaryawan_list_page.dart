import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../nav.dart';
import 'datakaryawan_item.dart';

class KaryawanListPage extends StatefulWidget {
  final DocumentSnapshot userData;

  const KaryawanListPage({required this.userData});

  @override
  State<KaryawanListPage> createState() => _KaryawanListPageState();
}

class _KaryawanListPageState extends State<KaryawanListPage> {
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
            child: Column(children: [
              Container(
                  height: 160,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25))),
                  child: Column(children: [
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 40, left: 20, right: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/logo.png', width: 40)
                            ])),
                    Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(Icons.keyboard_backspace_outlined,
                                      size: 35, color: Colors.black)),
                              Text('Daftar TKJP',
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(width: 50)
                            ]))
                  ])),
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
                      })),
              Expanded(
                  child: KaryawanItem(
                      searchQuery: searchQuery, userData: widget.userData))
            ])),
        floatingActionButton: widget.userData['role'] == 'Admin'
            ? FloatingActionButton(
                onPressed: () {
                  navToAdd(context);
                },
                tooltip: 'Tambah Pekerja',
                child: Icon(Icons.add),
              )
            : null);
  }
}
