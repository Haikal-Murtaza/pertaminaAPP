import 'package:flutter/material.dart';

class EmployeeListPage extends StatefulWidget {
  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  var email = '';

  void _addEmployee() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(title: Text('Employee 1')),
            ListTile(title: Text('Employee 2')),
            ListTile(title: Text('Employee 3')),
            // Add more employee list items here
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmployee,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
