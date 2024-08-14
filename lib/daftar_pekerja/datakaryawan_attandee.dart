import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KaryawanAttandeeData extends StatefulWidget {
  final DocumentSnapshot documentUsers;

  const KaryawanAttandeeData({required this.documentUsers});
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
            title: Text(
                'Daftar Kehadiran ${widget.documentUsers['nama_karyawan']}')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              DropdownButton<String>(
                  value: selectedMonth,
                  onChanged: (value) {
                    setState(() {
                      selectedMonth = value!;
                    });
                  },
                  items: months
                      .map((month) => DropdownMenuItem(
                          value: month, child: Text(month.toUpperCase())))
                      .toList()),
              SizedBox(height: 16.0),
              Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4, childAspectRatio: 1.2),
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
                                    color: attendanceDays[index]
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(child: Text('${index + 1}'))));
                      })),
              Divider(),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Kode Warna:", style: TextStyle(fontSize: 13))),
              _buildLegend(),
              SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: saveAttendance, child: Text('Save Attendance'))
            ])));
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildLegendItem('Hadir', Colors.green),
        _buildLegendItem('Absent', Colors.red),
        _buildLegendItem('Libur', Colors.blue),
        _buildLegendItem('Izin', Colors.orange),
        _buildLegendItem('kosong', Colors.grey),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Container(
        width: 40,
        height: 20,
        color: color,
        child: Center(
            child: Text(label,
                style: TextStyle(color: Colors.white, fontSize: 10))));
  }

  void saveAttendance() async {
    if (selectedStaffUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a staff member.')));
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
