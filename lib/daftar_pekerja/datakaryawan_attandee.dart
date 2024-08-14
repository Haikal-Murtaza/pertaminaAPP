import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KaryawanAttandeeData extends StatefulWidget {
  @override
  _KaryawanAttandeeData createState() => _KaryawanAttandeeData();
}

class _KaryawanAttandeeData extends State<KaryawanAttandeeData> {
  String? selectedStaffUid;
  String selectedMonth = 'january';
  List<bool> attendanceDays = List.generate(31, (index) => false);
  final List<String> months = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for selecting a staff member
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('data_karyawan')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                List<DropdownMenuItem<String>> staffItems = snapshot.data!.docs
                    .map((doc) => DropdownMenuItem<String>(
                          value: doc.id,
                          child: Text(doc['nama_karyawan']),
                        ))
                    .toList();

                return DropdownButton<String>(
                  hint: Text('Select Staff Member'),
                  value: selectedStaffUid,
                  onChanged: (value) {
                    setState(() {
                      selectedStaffUid = value;
                    });
                  },
                  items: staffItems,
                );
              },
            ),
            SizedBox(height: 16.0),
            // Dropdown for selecting the month
            DropdownButton<String>(
              value: selectedMonth,
              onChanged: (value) {
                setState(() {
                  selectedMonth = value!;
                });
              },
              items: months
                  .map((month) => DropdownMenuItem(
                        value: month,
                        child: Text(month.toUpperCase()),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16.0),
            // Grid to mark attendance for each day of the month
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.5,
                ),
                itemCount: attendanceDays.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        attendanceDays[index] = !attendanceDays[index];
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color:
                            attendanceDays[index] ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text('${index + 1}'),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            // Button to save attendance data
            ElevatedButton(
              onPressed: saveAttendance,
              child: Text('Save Attendance'),
            ),
          ],
        ),
      ),
    );
  }

  void saveAttendance() async {
    if (selectedStaffUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a staff member.'),
      ));
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(selectedStaffUid)
          .set({
        selectedMonth: attendanceDays.map((day) => day ? 1 : 0).toList(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Attendance saved successfully!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error saving attendance: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
