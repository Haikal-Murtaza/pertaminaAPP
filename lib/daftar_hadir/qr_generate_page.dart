import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String qrData = DateTime.now().toIso8601String();
    final String todayDate =
        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()); // Format date

    return Scaffold(
      appBar: AppBar(
        title: Text('Generate QR Code'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Today\'s Date: $todayDate', // Display today's date
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add your logic here to generate the QR code or any other actions
            },
            child: Text('Generate QR Code'),
          ),
          SizedBox(height: 20),
          Center(
            child: QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 500,
            ),
          ),
        ],
      ),
    );
  }
}
