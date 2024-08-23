import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pertamina_app/daftar_hadir/scanqr.dart';

class AttendancePage extends StatefulWidget {
  final DocumentSnapshot userData;

  const AttendancePage({required this.userData});
  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
  Map<int, String> attendanceStatus = {};
  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      String userId = widget.userData.id;
      String month = DateFormat('MMMM').format(DateTime.now()).toLowerCase();

      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(userId)
          .get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        List<dynamic>? days = data?[month];
        if (days != null) {
          setState(() {
            for (int i = 0; i < days.length; i++) {
              attendanceStatus[i + 1] = _getStatusFromValue(days[i]);
            }
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error fetching attendance data: $e'),
          backgroundColor: Colors.red));
    }
  }

  String _getStatusFromValue(dynamic value) {
    switch (value) {
      case 1:
        return 'Hadir';
      case 2:
        return 'Absent';
      case 3:
        return 'Libur';
      case 4:
        return 'Cuti';
      default:
        return 'Kosong';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: AppBar(backgroundColor: Colors.red)),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Daftar hadir anda bulan $currentMonth:",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              SizedBox(height: 10),
              Expanded(
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6),
                      itemCount: DateTime.now().day,
                      itemBuilder: (context, index) {
                        String status = attendanceStatus[index + 1] ?? 'blank';
                        return Container(
                            decoration: BoxDecoration(
                              color: _getColorForStatus(status),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                                child: Text('${index + 1}',
                                    style: TextStyle(color: Colors.white))));
                      })),
              Divider(),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Kode Warna:", style: TextStyle(fontSize: 13))),
              _buildLegend(),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => QRScanPage()));
                  },
                  child: Text('Scan QR'))
            ])));
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildLegendItem('Hadir', Colors.green),
        _buildLegendItem('Absent', Colors.red),
        _buildLegendItem('Libur', Colors.blue),
        _buildLegendItem('Cuti', Colors.orange),
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

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'Hadir':
        return Colors.green;
      case 'Absent':
        return Colors.red;
      case 'Libur':
        return Colors.blue;
      case 'Cuti':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
