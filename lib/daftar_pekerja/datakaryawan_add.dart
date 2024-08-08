import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AddDataKaryawanPage extends StatefulWidget {
  @override
  State<AddDataKaryawanPage> createState() => _AddDataKaryawanPageState();
}

class _AddDataKaryawanPageState extends State<AddDataKaryawanPage> {
  final TextEditingController namaKaryawan = TextEditingController();
  final TextEditingController idKaryawan = TextEditingController();
  final TextEditingController emailKaryawan = TextEditingController();

  String selectedRoleKaryawan = 'TKJP';

  List<String> roleOptions = [
    'Admin',
    'Approver',
    'Reviewer',
    'TKJP',
  ];

  File? _image;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double setWidth = deviceWidth;

    return Scaffold(
        appBar: AppBar(title: Text('Tambah Data Karyawan')),
        body: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0, blurRadius: 4, offset: Offset(0, 1))
                ]),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  Center(
                      child: GestureDetector(
                          onTap: _updateProfilePicture,
                          child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : AssetImage(
                                          'assets/default_profile_picture.png')
                                      as ImageProvider))),
                  buildTextField('Nama Karyawan', namaKaryawan, setWidth),
                  buildTextField('NO ID', idKaryawan, setWidth),
                  buildTextField('Email Karyawan', emailKaryawan, setWidth),
                  buildDropdown(setWidth),
                  buildButton('Add', Colors.grey, _addKaryawan)
                ]))));
  }

  Widget buildTextField(
      String label, TextEditingController controller, double width,
      {bool isMultiLine = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          height: 60,
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(fontSize: 18))),
      SizedBox(
          height: 60,
          width: width,
          child: TextFormField(
              controller: controller,
              textAlignVertical: isMultiLine
                  ? TextAlignVertical.top
                  : TextAlignVertical.bottom,
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              decoration: InputDecoration(border: OutlineInputBorder())))
    ]);
  }

  Widget buildDropdown(double width) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          height: 60,
          alignment: Alignment.centerLeft,
          child: Text('Role', style: TextStyle(fontSize: 18))),
      SizedBox(
          height: 60,
          width: width,
          child: DropdownButtonFormField(
              value: selectedRoleKaryawan,
              items: roleOptions.map((String option) {
                return DropdownMenuItem(value: option, child: Text(option));
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedRoleKaryawan = newValue.toString();
                });
              },
              decoration: InputDecoration(border: OutlineInputBorder())))
    ]);
  }

  Widget buildButton(String label, Color color, Function onPressed) {
    return Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(horizontal: 8),
        height: 50,
        width: 150,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: color)),
        child: GestureDetector(
            onTap: () => onPressed(context),
            child: Center(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))));
  }

  void _addKaryawan(BuildContext context) async {
    try {
      String nama = namaKaryawan.text.trim();
      String id = idKaryawan.text.trim();
      String email = emailKaryawan.text.trim();
      String role = selectedRoleKaryawan.trim();
      String password = 'pertamina'; // Default password untuk new user

      if (nama.isNotEmpty && email.isNotEmpty) {
        // Save the current admin user
        User? currentUser = FirebaseAuth.instance.currentUser;

        // Create user in Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String uid = userCredential.user!.uid;

        // Upload profile picture to Firebase Storage
        String? profileImageUrl;
        if (_image != null) {
          profileImageUrl = await _uploadImageToFirebase(_image!, uid);
        }

        // Add user data to Firestore with the UID as the document ID
        await FirebaseFirestore.instance
            .collection('data_karyawan')
            .doc(uid)
            .set({
          'nama_karyawan': nama,
          'id_karyawan': id,
          'email_karyawan': email,
          'role': role,
          'profile_picture': profileImageUrl,
        });

        // Sign out the newly created user
        await FirebaseAuth.instance.signOut();

        // Re-sign in the original admin user
        if (currentUser != null) {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: currentUser.email!, password: 'admincontrol');
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Data Karyawan berhasil ditambahkan!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4)));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Mohon masukkan data yang benar!'),
            duration: Duration(seconds: 2)));
      }
    } catch (e) {
      print('Error adding karyawan: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred. Please try again later.'),
          duration: Duration(seconds: 2)));
    }
  }

  Future<void> _updateProfilePicture() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImageToFirebase(File image, String uid) async {
    String fileName = 'profile_pictures/$uid.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }
}
