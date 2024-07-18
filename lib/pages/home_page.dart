import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'task_list_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title for Section 1
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text('Task Based Categories',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              // Section 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCard(context, 'Health', 10, Colors.orange),
                  _buildCard(context, 'Safety', 8, Colors.red),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCard(context, 'Security', 15, Colors.blue),
                  _buildCard(context, 'Environment', 20, Colors.green),
                ],
              ),
              SizedBox(height: 20),
              // Title for Section 2
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text('Task Based Months',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              // Section 2
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(12, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskListPage(
                            category:
                                'Tasks for ${DateFormat('MMMM').format(DateTime(0, index + 1))}',
                            tasks: 10, // You can set tasks based on your logic
                            month: DateFormat('MMMM')
                                .format(DateTime(0, index + 1)),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Center(
                        child: Text(
                          DateFormat('MMM').format(DateTime(0, index + 1)),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi membuat card category tugas
  Widget _buildCard(BuildContext context, String name, int tasks, Color color) {
    double progress = tasks / 20; // Dummy progress value
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskListPage(category: name, tasks: tasks),
            ),
          );
        },
        child: Card(
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: Colors.white, fontSize: 16)),
                SizedBox(height: 8),
                Text('Tasks: $tasks', style: TextStyle(color: Colors.white)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text('${(progress * 100).toInt()}%',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
