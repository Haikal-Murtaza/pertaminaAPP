import 'package:flutter/material.dart';

import '../nav.dart';
import 'stok_list.dart';

class StockListPage extends StatefulWidget {
  @override
  State<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends State<StockListPage> {
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
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Pekerja'), actions: [
        IconButton(
            icon: Icon(Icons.add, color: Colors.white, size: 40),
            onPressed: () {
              navEmployeePage(context);
            })
      ]),
      body: Expanded(child: StockList(searchQuery: searchQuery)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navToAdd(context);
        },
        tooltip: 'Add Employee',
        child: Icon(Icons.add),
      ),
    );
  }
}
