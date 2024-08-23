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
  List<int> attendanceDays = List.generate(31, (index) => 0); // Status codes
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

  final Map<int, String> statusLabels = {
    0: 'Kosong',
    1: 'Hadir',
    2: 'Absent',
    3: 'Libur',
    4: 'Cuti',
  };

  @override
  void initState() {
    super.initState();
    selectedStaffUid = widget.documentUsers.id;
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(selectedStaffUid)
          .get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        List<int>? days = List<int>.from(data?[selectedMonth] ?? []);
        setState(() {
          attendanceDays =
              days.length == 31 ? days : List.generate(31, (index) => 0);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error fetching attendance: $e'),
          backgroundColor: Colors.red));
    }
  }

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
                    fetchAttendanceData();
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
                            onTap: () => _selectStatus(context, index),
                            child: Container(
                                margin: EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    color: _getColorForStatus(
                                        attendanceDays[index]),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: Center(
                                    child: Text(
                                  '${index + 1}\n${statusLabels[attendanceDays[index]]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ))));
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
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      _buildLegendItem('Kosong', Colors.grey),
      _buildLegendItem('Hadir', Colors.green),
      _buildLegendItem('Absent', Colors.red),
      _buildLegendItem('Libur', Colors.blue),
      _buildLegendItem('Cuti', Colors.orange),
    ]);
  }

  Widget _buildLegendItem(String label, Color color) {
    return Container(
        width: 60,
        height: 20,
        color: color,
        margin: EdgeInsets.only(right: 8.0),
        child: Center(
            child: Text(label,
                style: TextStyle(color: Colors.white, fontSize: 10))));
  }

  Future<void> _selectStatus(BuildContext context, int index) async {
    final selectedStatus = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Status'),
          children: statusLabels.entries.map((entry) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, entry.key);
              },
              child: Text(entry.value),
            );
          }).toList(),
        );
      },
    );

    if (selectedStatus != null) {
      setState(() {
        attendanceDays[index] = selectedStatus;
      });
    }
  }

  Color _getColorForStatus(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
        selectedMonth: attendanceDays,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Attendance saved successfully!'),
          backgroundColor: Colors.green));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error saving attendance: $e'),
          backgroundColor: Colors.red));
    }
  }
}
