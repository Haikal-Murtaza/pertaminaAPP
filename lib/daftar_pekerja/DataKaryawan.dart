// ignore_for_file: unused_element, sized_box_for_whitespace, file_names

import 'package:flutter/material.dart';

import '../nav.dart';
import 'KaryawanItem.dart';

class KaryawanListPage extends StatefulWidget {
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
        body: Container(
            height: deviceHeight,
            width: deviceWidth,
            child: Column(children: [
              Container(
                  height: 170,
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
                              Image.asset('assets/logo.png', width: 150),
                              Icon(Icons.account_circle_outlined, size: 50)
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
                                  icon: Icon(
                                    Icons.keyboard_backspace_outlined,
                                    size: 35,
                                    color: Colors.black,
                                  )),
                              Text('Daftar TKJP',
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(width: 50)
                            ]))
                  ])),
              Expanded(child: KaryawanItem(searchQuery: searchQuery))
            ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              navToAdd(context);
            },
            tooltip: 'Add Employee',
            child: Icon(Icons.add)));
  }
}
