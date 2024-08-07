import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DetailsDataKaryawanPage extends StatefulWidget {
  final DocumentSnapshot document;

  DetailsDataKaryawanPage({required this.document});

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
        TextEditingController(text: widget.document['nama_karyawan']);
    idKaryawan = TextEditingController(text: widget.document['id_karyawan']);
    emailKaryawan =
        TextEditingController(text: widget.document['email_karyawan']);

    selectedRoleKaryawan = widget.document['role'] ?? roleOptions[3];
    _profileImageUrl = widget.document['profile_picture'];
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
            BoxShadow(spreadRadius: 0, blurRadius: 4, offset: Offset(0, 1))
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
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
                                    as ImageProvider,
                      ))),
              buildTextField(
                  'Nama Karyawan', namaKaryawan, setWidth, isEditMode),
              buildTextField('NO ID', idKaryawan, setWidth, isEditMode),
              buildTextField('Email Karyawan', emailKaryawan, setWidth, false),
              buildDropdown(setWidth, isEditMode),
              buildButton(
                  isEditMode ? 'Save' : 'Edit', Colors.orange, _toggleEditMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      double width, bool isEditMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(fontSize: 18)),
        ),
        SizedBox(
          height: 60,
          width: width,
          child: TextFormField(
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            style: TextStyle(fontSize: 16),
            maxLines: 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            enabled: isEditMode,
          ),
        ),
      ],
    );
  }

  Widget buildDropdown(double width, bool isEditMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          child: Text('Role', style: TextStyle(fontSize: 18)),
        ),
        SizedBox(
          height: 60,
          width: width,
          child: DropdownButtonFormField(
            value: selectedRoleKaryawan,
            items: roleOptions.map((String option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: isEditMode
                ? (newValue) {
                    setState(() {
                      selectedRoleKaryawan = newValue.toString();
                    });
                  }
                : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            disabledHint: Text(selectedRoleKaryawan),
          ),
        ),
      ],
    );
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
        border: Border.all(color: color),
      ),
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
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
          .doc(widget.document.id)
          .update({
        'nama_karyawan': namaKaryawan.text,
        'id_karyawan': idKaryawan.text,
        'role': selectedRoleKaryawan,
        'profile_picture': _profileImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data Karyawan berhasil diperbarui!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ));
    } catch (e) {
      print('Error updating karyawan: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        duration: Duration(seconds: 2),
      ));
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
    String fileName = 'profile_pictures/${widget.document.id}.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.whenComplete(() => null);
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  }
}
