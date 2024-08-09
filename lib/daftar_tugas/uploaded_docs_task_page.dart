import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;

class UploadedDocsPage extends StatelessWidget {
  final String taskId;
  final String taskName;

  UploadedDocsPage({required this.taskId, required this.taskName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents for $taskName'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('data_tugas')
            .doc(taskId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No documents uploaded yet.'));
          }

          var task = snapshot.data!;
          var docs = task['documents'];

          if (docs is! List<dynamic>) {
            return ListTile(
              title: Text('Invalid documents format for this task'),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var doc = docs[index];
              if (doc is! Map<String, dynamic>) {
                return ListTile(
                  title: Text('Invalid document format'),
                );
              }

              String docUrl = doc['url'] ?? '';
              String docName = doc['name'] ?? getFileName(docUrl);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      docName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.download),
                      onPressed: () {
                        downloadFileToStorage(docUrl, docName, context);
                      },
                    ),
                  ),
                  FutureBuilder<File?>(
                    future: _downloadFile(docUrl),
                    builder: (context, fileSnapshot) {
                      if (fileSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (fileSnapshot.hasError) {
                        print('File snapshot error: ${fileSnapshot.error}');
                        return Center(
                            child: Text('Error: ${fileSnapshot.error}'));
                      } else if (!fileSnapshot.hasData ||
                          fileSnapshot.data == null) {
                        print('File snapshot data is null or empty');
                        return Center(child: Text('Failed to load PDF'));
                      } else {
                        print('PDF file path: ${fileSnapshot.data!.path}');
                        return SizedBox(
                          height: 300,
                          child: PDFView(
                            filePath: fileSnapshot.data!.path,
                          ),
                        );
                      }
                    },
                  ),
                  Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String getFileName(String url) {
    return Uri.decodeComponent(url.split('/').last.split('?').first);
  }

  Future<File?> _downloadFile(String url) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(url);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, getFileName(url));
      final file = File(filePath);

      print('Attempting to download file to: $filePath');
      await ref.writeToFile(file);

      // Ensure the file exists
      if (await file.exists()) {
        print('File downloaded successfully: ${file.path}');
        return file;
      } else {
        print('File does not exist after download');
        return null;
      }
    } catch (e) {
      print('Failed to download file: $e');
      return null;
    }
  }

  Future<void> downloadFileToStorage(
      String url, String fileName, BuildContext context) async {
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Storage permission is required to download files.'),
        ));
        return;
      }

      // Get a reference to the file in Firebase Storage using the URL
      final ref = FirebaseStorage.instance.refFromURL(url);

      // Get the external storage directory
      final externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        print('Could not get external storage directory.');
        return;
      }

      // Decode the file name from the URL (important for handling special characters)
      final decodedFileName = Uri.decodeComponent(fileName);
      final localFilePath = path.join(externalDir.path, decodedFileName);

      final file = File(localFilePath);

      // Debugging output
      print('Attempting to download file to: $localFilePath');

      // Download the file
      await ref.writeToFile(file);

      if (await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('File downloaded to ${file.path}'),
        ));
      } else {
        print('File does not exist after download');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('File download failed. File does not exist.'),
        ));
      }
    } catch (e) {
      print('Failed to download file: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to download file: $e'),
      ));
    }
  }
}
