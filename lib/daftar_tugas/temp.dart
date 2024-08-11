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
  bool isLoading = false;
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Documents for ${widget.taskName}')),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('data_tugas')
                    .doc(widget.taskId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('No documents available.'));
                  }

                  var docs = snapshot.data!['documents'] as List<dynamic>;

                  if (docs.isEmpty) {
                    return Center(child: Text('No documents uploaded yet.'));
                  }

                  return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var doc = docs[index];
                        String docUrl = doc['url'];
                        String docName = getFileName(docUrl);

                        return Card(
                            child: ExpansionTile(
                                key: Key(index.toString()),
                                initiallyExpanded: expandedIndex == index,
                                title: Text(docName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                trailing: IconButton(
                                    icon: Icon(Icons.download),
                                    onPressed: () async {
                                      if (await canLaunchUrl(docUrl as Uri)) {
                                        await launchUrl(docUrl as Uri);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Could not open the file",
                                            textColor: Colors.red);
                                      }
                                    }),
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    expandedIndex = expanded ? index : null;
                                  });
                                },
                                children: [
                              SizedBox(
                                  height: 200,
                                  child: PDFView(
                                      filePath: doc['filePath'],
                                      onRender: (_) => setState(() {}))),
                              Divider(),
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: Text('Button'),
                              )
                            ]));
                      });
                }));
  }

  String getFileName(String url) {
    return Uri.decodeComponent(url.split('/').last.split('?').first);
  }

  void loadDocuments() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('data_tugas')
          .doc(widget.taskId)
          .get();

      setState(() {
        isLoading = false;
      });

      if (!doc.exists) {
        Fluttertoast.showToast(msg: "Task not found", textColor: Colors.red);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error $e", textColor: Colors.red);
    }
  }
}
