import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanPage extends StatelessWidget {
  final String userId;
  final MobileScannerController cameraController = MobileScannerController();

  QRScanPage({required this.userId});

  Future<void> updateAttendanceStatus(
      BuildContext context, String userId, String scannedQr) async {
    String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    String todayDay = DateFormat('d').format(DateTime.now());
    String currentMonth =
        DateFormat('MMMM').format(DateTime.now()).toLowerCase();

    DocumentSnapshot qrDoc = await FirebaseFirestore.instance
        .collection('qr_codes')
        .doc(todayDate)
        .get();

    if (qrDoc.exists && qrDoc['data'] == scannedQr) {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('attendance').doc(userId);

      await userDoc.set({
        currentMonth: {todayDay: 1}
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Attendance updated successfully.'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid or outdated QR code.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
        backgroundColor: Colors.red,
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) async {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              await updateAttendanceStatus(context, userId, code);
              await Future.delayed(Duration(milliseconds: 300));
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          }
        },
      ),
    );
  }
}
