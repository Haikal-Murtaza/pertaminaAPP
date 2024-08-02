import 'package:flutter/material.dart';
import 'package:pertamina_app/nav.dart';
import 'datatugas_item.dart';

class TaskListPage extends StatefulWidget {
  final String category;
  final int tasks;
  final String month;

  TaskListPage({required this.category, required this.tasks, this.month = ''});

  @override
  State<TaskListPage> createState() => _TaskListPage();
}

class _TaskListPage extends State<TaskListPage> {
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
            Expanded(child: TugasItem(searchQuery: searchQuery)),
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
}
