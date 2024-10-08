import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailsDataKaryawanPage extends StatefulWidget {
  final DocumentSnapshot documentUsers;

  DetailsDataKaryawanPage({required this.documentUsers});

  @override
  State<DetailsDataKaryawanPage> createState() =>
      _DetailsDataKaryawanPageState();
}

class _DetailsDataKaryawanPageState extends State<DetailsDataKaryawanPage> {
  late TextEditingController namaKaryawan = TextEditingController();
  late TextEditingController idKaryawan = TextEditingController();
  late TextEditingController emailKaryawan = TextEditingController();

  String selectedRoleKaryawan = 'TKJP';
  File? _image;
  String? _profileImageUrl;

  bool isEditMode = false;
  bool isAdmin = false;

  List<String> roleOptions = [
    'Admin',
    'Approver',
    'Reviewer',
    'TKJP',
  ];

  @override
  void initState() {
    super.initState();
    namaKaryawan =
        TextEditingController(text: widget.documentUsers['nama_karyawan']);
    idKaryawan =
        TextEditingController(text: widget.documentUsers['id_karyawan']);
    emailKaryawan =
        TextEditingController(text: widget.documentUsers['email_karyawan']);

    selectedRoleKaryawan = widget.documentUsers['role'] ?? roleOptions[3];
    _profileImageUrl = widget.documentUsers['profile_picture'];

    _checkAdminRole();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double setWidth = deviceWidth;

    return Scaffold(
        appBar: AppBar(title: Text('Rincian Karyawan')),
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
                          onTap: isEditMode ? _updateProfilePicture : null,
                          child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : _profileImageUrl != null
                                      ? NetworkImage(_profileImageUrl!)
                                      : AssetImage(
                                              'assets/default_profile_picture.png')
                                          as ImageProvider))),
                  buildTextField(
                      'Nama Karyawan', namaKaryawan, setWidth, isEditMode),
                  buildTextField('NO ID', idKaryawan, setWidth, isEditMode),
                  buildTextField(
                      'Email Karyawan', emailKaryawan, setWidth, false),
                  buildDropdown(setWidth, isEditMode),
                  if (isAdmin)
                    Row(children: [
                      buildButton(isEditMode ? 'Save' : 'Edit', Colors.orange,
                          _toggleEditMode),
                      buildButton('Reset Pass', Colors.blue, _changePassword)
                    ])
                ]))));
  }

  Future<void> _checkAdminRole() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('data_karyawan')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists && userDoc['role'] == 'Admin') {
        setState(() {
          isAdmin = true;
        });
      }
    }
  }

  Widget buildTextField(String label, TextEditingController controller,
      double width, bool isEditMode) {
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
              textAlignVertical: TextAlignVertical.bottom,
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              decoration: InputDecoration(border: OutlineInputBorder()),
              enabled: isEditMode))
    ]);
  }

  Widget buildDropdown(double width, bool isEditMode) {
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
              onChanged: isEditMode
                  ? (newValue) {
                      setState(() {
                        selectedRoleKaryawan = newValue.toString();
                      });
                    }
                  : null,
              decoration: InputDecoration(border: OutlineInputBorder()),
              disabledHint: Text(selectedRoleKaryawan)))
    ]);
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
            border: Border.all(color: color)),
        child: GestureDetector(
            onTap: () => onPressed(),
            child: Center(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)))));
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
      if (!isEditMode) {
        _saveKaryawan();
      }
    });
  }

  void _saveKaryawan() async {
    try {
      if (_image != null) {
        _profileImageUrl = await _uploadImageToFirebase(_image!);
      }

      await FirebaseFirestore.instance
          .collection('data_karyawan')
          .doc(widget.documentUsers.id)
          .update({
        'nama_karyawan': namaKaryawan.text,
        'id_karyawan': idKaryawan.text,
        'role': selectedRoleKaryawan,
        'profile_picture': _profileImageUrl
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data Karyawan berhasil diperbarui!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4)));
    } catch (e) {
      print('Error updating karyawan: $e');
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

  Future<String> _uploadImageToFirebase(File image) async {
    String fileName = 'profile_pictures/${widget.documentUsers.id}.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _changePassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: widget.documentUsers['email_karyawan']);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Password reset email sent to ${widget.documentUsers['email_karyawan']}'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to send password reset email: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4)));
    }
  }
}
