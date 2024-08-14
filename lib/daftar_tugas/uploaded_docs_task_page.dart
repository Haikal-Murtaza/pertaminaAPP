import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadedDocsPage extends StatefulWidget {
  final DocumentSnapshot documentTask;
  final int value;

  UploadedDocsPage({required this.documentTask, required this.value});

  @override
  _UploadedDocsPageState createState() => _UploadedDocsPageState();
}

class _UploadedDocsPageState extends State<UploadedDocsPage> {
  File? file;
  String? url;
  String? name;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadFileUrl();
  }

  @override
  Widget build(BuildContext context) {
    String? label1;
    String? status1;
    String? label2;
    String? status2;

    switch (widget.value) {
      case 1:
        label1 = 'Approve';
        status1 = 'Progress';
        label2 = 'Ask to Revise';
        status2 = 'Ask to Revise';
      case 2:
        label1 = 'Approve';
        status1 = 'Completed';
        label2 = 'Denied';
        status2 = 'Denied';
      case 3:
        label1 = null;
        label2 = null;
      default:
        label1 = 'Approve';
        status1 = 'Progress';
        label2 = 'Ask to Revise';
        status2 = 'Ask to Revise';
    }

    return Scaffold(
        appBar: AppBar(title: Text(widget.documentTask['nama_tugas'])),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
              title: Text(name ?? 'No document available',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () {
                    downloadFile();
                  })),
          Center(
              child: isLoading
                  ? CircularProgressIndicator()
                  : url != null
                      ? SizedBox(
                          height: 600,
                          width: 380,
                          child: PDFView(
                              filePath: file?.path,
                              onRender: (_) => setState(() {})))
                      : InkWell(
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(url!))) {
                              await launchUrl(Uri.parse(url!));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Tidak dapat manampilkan Pdf"),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 3)));
                            }
                          },
                          child: Text('Pdf tidak tersedia'))),
          Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            if (label1 != null)
              buildButton(
                  label1, Colors.green, () => confirmStatusChange(status1!)),
            if (label2 != null)
              buildButton(
                  label2, Colors.orange, () => confirmStatusChange(status2!))
          ])
        ]));
  }

  Widget buildButton(String label, Color color, Function onPressed) {
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 50,
        width: 130,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: color),
        ),
        child: GestureDetector(
            onTap: () => onPressed(),
            child: Center(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))));
  }

  Future<void> confirmStatusChange(String status) async {
    bool? confirmed = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Pesan Konfimasi'),
              content: Text(
                  'Apakah anda yakin untuk mengubah status tugas menjadi "$status"?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Batal'),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('Konfirmasi'))
              ]);
        });

    if (confirmed == true) {
      setStatus(status);
    }
  }

  Future<void> setStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('data_tugas')
          .doc(widget.documentTask.id)
          .update({'status': status});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to update status"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3)));
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Status telah di update'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3)));
    Navigator.pop(context);
  }

  void loadFileUrl() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('data_tugas')
          .doc(widget.documentTask.id)
          .get();

      setState(() {
        var uploadDocument = doc['uploadDocument'];
        url = uploadDocument['url'];
        file = File(uploadDocument['filePath']);
        name = uploadDocument['name'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3)));
    }
  }

  Future<void> downloadFile() async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      try {
        Directory? downloadsDirectory;
        if (Platform.isAndroid) {
          downloadsDirectory = Directory('/storage/emulated/0/Download');
        } else {
          downloadsDirectory = await getApplicationDocumentsDirectory();
        }
        String filePath = "${downloadsDirectory.path}/$name";

        Dio dio = Dio();
        await dio.download(url!, filePath);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("File downloaded to $filePath"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3)));

        setState(() {
          loadFileUrl();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Read External Storage permission denied"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3)));
    }
  }
}
