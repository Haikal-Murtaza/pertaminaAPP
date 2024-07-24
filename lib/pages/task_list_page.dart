import 'package:flutter/material.dart';

class TaskListPage extends StatelessWidget {
  final String category;
  final int tasks;
  final String month;

  TaskListPage({required this.category, required this.tasks, this.month = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          title: Text(
            'Tugas Rutin dan Non Rutin ${month.isEmpty ? category : "bulan $month"}',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor:
              Colors.blue, // Set your desired background color here
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table( 
              border: TableBorder
                  .all(), // Add this to get lines between rows and columns
              columnWidths: const {
                0: FixedColumnWidth(50.0),
                1: FixedColumnWidth(150.0),
                2: FixedColumnWidth(100.0),
                3: FixedColumnWidth(100.0),
                4: FixedColumnWidth(100.0),
                5: FixedColumnWidth(100.0),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  children: [
                    TableCell(child: Center(child: Text('No'))),
                    TableCell(child: Center(child: Text('Name of Task'))),
                    TableCell(child: Center(child: Text('PIC'))),
                    TableCell(child: Center(child: Text('Frequency'))),
                    if (month.isNotEmpty)
                      TableCell(child: Center(child: Text('Month'))),
                    TableCell(child: Center(child: Text('Action'))),
                  ],
                ),
                ...List<TableRow>.generate(
                  tasks,
                  (index) => TableRow(
                    children: [
                      TableCell(
                          child: Center(child: Text((index + 1).toString()))),
                      TableCell(
                          child: Center(child: Text('Task ${index + 1}'))),
                      TableCell(
                          child: Center(
                              child: Text('Person ${index + 1}'))), // Dummy PIC
                      TableCell(
                          child:
                              Center(child: Text('Daily'))), // Dummy frequency
                      if (month.isNotEmpty)
                        TableCell(
                            child: Center(child: Text(month))), // Dummy month
                      TableCell(
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Action button logic
                            },
                            child: Text('Action'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
