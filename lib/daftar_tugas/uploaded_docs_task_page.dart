import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadedDocsPage extends StatefulWidget {
  final String taskId;
  final String taskName;

  UploadedDocsPage({required this.taskId, required this.taskName});

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
    return Scaffold(
        appBar: AppBar(title: Text(widget.taskName)),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
              title: Text(
                  name ??
                      (url != null
                          ? getFileName(url!)
                          : 'No document available'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              trailing: IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () {
                    // not implemented yet
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
                              onRender: (_) => setState(() {})),
                        )
                      : InkWell(
                          onTap: () async {
                            if (await canLaunchUrl(Uri.parse(url!))) {
                              await launchUrl(Uri.parse(url!));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Tidak dapat menampilkan Pdf",
                                  textColor: Colors.red);
                            }
                          },
                          child: Text('Pdf tidak tersedia'))),
          Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            buildButton('Approve', Colors.green, exit),
            buildButton('Ask to Revise', Colors.orange, exit)
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

  String getFileName(String url) {
    return Uri.decodeComponent(url.split('/').last.split('?').first);
  }

  void exit() {
    Navigator.of(context).pop();
  }

  void loadFileUrl() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('data_tugas')
          .doc(widget.taskId)
          .get();

      setState(() {
        var uploadDocument = doc['uploadDocument']; // Assuming it's a Map
        url = uploadDocument['url'];
        file = File(uploadDocument['filePath']);
        name = uploadDocument['name'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error $e", textColor: Colors.red);
    }
  }
}
