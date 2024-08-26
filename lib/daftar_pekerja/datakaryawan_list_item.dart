import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pertamina_app/nav.dart';

class KaryawanListItem extends StatefulWidget {
  final DocumentSnapshot documentUsers;
  final DocumentSnapshot userData;
  const KaryawanListItem({required this.documentUsers, required this.userData});

  @override
  _KaryawanListItemState createState() => _KaryawanListItemState();
}

class _KaryawanListItemState extends State<KaryawanListItem> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.userData['role'] == 'Admin';

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        height: 170,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color.fromARGB(255, 217, 217, 217)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Nama : ${widget.documentUsers['nama_karyawan']}",
                        style: TextStyle(fontSize: 16)),
                    Text("No ID : ${widget.documentUsers['id_karyawan']}",
                        style: TextStyle(fontSize: 16)),
                    Text("Role : ${widget.documentUsers['role']}",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    SizedBox(
                        width: 120,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (isAdmin)
                                GestureDetector(
                                    onTap: () {
                                      if (_currentUser != null &&
                                          _currentUser!.email !=
                                              widget.documentUsers[
                                                  'email_karyawan']) {
                                        showDeleteConfirmationDialog(
                                            context, widget.documentUsers);
                                      } else {
                                        showCannotDeleteCurrentUserNotification(
                                            context);
                                      }
                                    },
                                    child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.orange.shade700,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10))),
                                        child: Icon(Icons.delete_outline,
                                            color: Colors.white))),
                              SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () {
                                    navToDetailsKaryawan(
                                        context, widget.documentUsers);
                                  },
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.orange.shade700,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: Icon(Icons.edit_square,
                                          color: Colors.white))),
                              SizedBox(width: 10),
                              GestureDetector(
                                  onTap: () {
                                    navToAttendeeData(context,
                                        widget.documentUsers, widget.userData);
                                  },
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: Colors.orange.shade700,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: Icon(Icons.library_books_outlined,
                                          color: Colors.white)))
                            ]))
                  ])),
          Container(
              margin: EdgeInsets.only(right: 15),
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.green),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.documentUsers['profile_picture'] != null
                      ? Image.network(widget.documentUsers['profile_picture'],
                          fit: BoxFit.cover, height: 130, width: 130)
                      : Image.asset('assets/default_profile_picture.png',
                          fit: BoxFit.cover, height: 130, width: 130)))
        ]));
  }

  void showDeleteConfirmationDialog(
      BuildContext context, DocumentSnapshot documentUsers) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Konfirmasi"),
              content: const Text("Apakah anda ingin menghapus data ini?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Batal")),
                TextButton(
                    onPressed: () {
                      deleteDataKaryawan(documentUsers);
                      Navigator.pop(context);
                      showDeleteSuccessNotification(context);
                    },
                    child: const Text("Hapus"))
              ]);
        });
  }

  void showCannotDeleteCurrentUserNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Anda tidak dapat menghapus user saat ini!"),
        backgroundColor: Color.fromARGB(255, 255, 17, 0),
        duration: Duration(seconds: 3)));
  }

  void showDeleteSuccessNotification(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User berhasil dihapus!"),
        backgroundColor: Color.fromARGB(255, 255, 17, 0),
        duration: Duration(seconds: 3)));
  }

  void deleteDataKaryawan(DocumentSnapshot documentUsers) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    try {
      String email = documentUsers['email_karyawan'];
      String userPassword = documentUsers['password'];
      String userRole = documentUsers['role'];

      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(documentUsers.id)
          .delete();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: userPassword);

      User? userToDelete = userCredential.user;

      if (userToDelete != null) {
        String profileImageUrl = documentUsers['profile_picture'] ?? '';
        if (profileImageUrl.isNotEmpty) {
          await FirebaseStorage.instance.refFromURL(profileImageUrl).delete();
        }

        await documentUsers.reference.delete();
        await userToDelete.delete();

        if (userRole == 'Admin') {
          await FirebaseFirestore.instance
              .collection('admin')
              .doc(documentUsers.id)
              .delete();
        }
      }

      if (currentUser != null) {
        DocumentSnapshot adminDoc = await FirebaseFirestore.instance
            .collection('admin')
            .doc(currentUser.uid)
            .get();

        String? adminPassword = adminDoc['password'];

        if (adminPassword != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: currentUser.email!, password: adminPassword);
        }
      }
    } catch (e) {
      print("Error deleting user: $e");

      if (currentUser != null) {
        DocumentSnapshot adminDoc = await FirebaseFirestore.instance
            .collection('admin')
            .doc(currentUser.uid)
            .get();

        String? adminPassword = adminDoc['password'];

        if (adminPassword != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: currentUser.email!, password: adminPassword);
        }
      }
    }
  }
}
