import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class QrCodeGeneratorPage extends StatefulWidget {
  @override
  _QrCodeGeneratorPageState createState() => _QrCodeGeneratorPageState();
}

class _QrCodeGeneratorPageState extends State<QrCodeGeneratorPage> {
  String? qrData;
  String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    checkIfQrGenerated();
  }

  Future<void> checkIfQrGenerated() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('qr_codes')
        .doc(todayDate)
        .get();

    if (doc.exists) {
      setState(() {
        qrData = doc['data'];
      });
    }
  }

  Future<void> generateQrCode() async {
    final String newQrData = DateTime.now().toIso8601String();

    await FirebaseFirestore.instance
        .collection('qr_codes')
        .doc(todayDate)
        .set({'data': newQrData, 'timestamp': Timestamp.now()});

    setState(() {
      qrData = newQrData;
    });
  }

  Future<void> downloadQrCode() async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      final directory = Directory('/storage/emulated/0/Download');
      final fileName = '${directory.path}/QRCode_$todayDate.png';

      screenshotController.capture().then((image) async {
        if (image != null) {
          final file = File(fileName);
          await file.writeAsBytes(image);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('QR Code saved to $fileName'),
            backgroundColor: Colors.green,
          ));
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error saving QR Code: $error'),
          backgroundColor: Colors.red,
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Storage permission is required to download the QR Code'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate QR Code')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20), // Space from the top
          Center(
            child: Text(
              'Today\'s Date: $todayDate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: qrData == null
                ? ElevatedButton(
                    onPressed: generateQrCode,
                    child: Text('Generate QR Code'),
                  )
                : Screenshot(
                    controller: screenshotController,
                    child: QrImageView(
                      data: qrData!,
                      version: QrVersions.auto,
                      size:
                          250, // Ensure the size is appropriate for most screens
                    ),
                  ),
          ),
          SizedBox(height: 20),
          if (qrData != null)
            ElevatedButton(
              onPressed: downloadQrCode,
              child: Text('Download QR Code'),
            ),
        ],
      ),
    );
  }
}
