import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void showDeleteConfirmationDialog(
    BuildContext context, DocumentSnapshot document) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Confirmation"),
        content: const Text("Are you sure you want to delete ?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteDataKaryawan(document);
              Navigator.pop(context);

              showDeleteSuccessNotification(context);
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}

void showDeleteSuccessNotification(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Delete success!"),
      duration: Duration(seconds: 3),
    ),
  );
}

void deleteDataKaryawan(DocumentSnapshot document) async {
  try {
    await document.reference.delete();

    print("Deleted successfully");
  } catch (e) {
    print("Error deleting: $e");
  }
}