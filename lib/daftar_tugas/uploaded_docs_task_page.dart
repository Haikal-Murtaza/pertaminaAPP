import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadFileUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents for ${widget.taskName}'),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : url != null
                ? Expanded(
                    child: PDFView(
                      filePath: file?.path,
                      onRender: (_) => setState(() {}),
                    ),
                  )
                : url != null
                    ? InkWell(
                        onTap: () async {
                          if (await canLaunchUrl(url as Uri)) {
                            await launchUrl(url as Uri);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Could not open the file",
                              textColor: Colors.red,
                            );
                          }
                        },
                      )
                    : Container(
                        child: Text('No documents available.'),
                      ),
      ),
    );
  }

  void loadFileUrl() async {
    try {
      // Load the URL and file path from Firestore based on the provided taskId
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('data_tugas')
          .doc(widget.taskId)
          .get();

      if (doc.exists) {
        var docs = doc['documents'];

        if (docs is List && docs.isNotEmpty) {
          var firstDoc =
              docs[0]; // Assuming you want to show the first document
          setState(() {
            url = firstDoc['url'];
            file = File(firstDoc['filePath']);
            isLoading = false;
          });
        } else {
          setState(() {
            url = null;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Error $e",
        textColor: Colors.red,
      );
    }
  }
}
