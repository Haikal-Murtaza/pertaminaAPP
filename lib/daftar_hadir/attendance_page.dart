import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pertamina_app/daftar_hadir/scanqr.dart';

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());

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
                        DateTime day = DateTime(DateTime.now().year,
                            DateTime.now().month, index + 1);
                        String status = _getStatusForDay(day);
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

  String _getStatusForDay(DateTime day) {
    // Implement logic to determine status for each day
    return 'blank';
  }

  Color _getColorForStatus(String status) {
    switch (status) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'holiday':
        return Colors.blue;
      case 'take leave':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
