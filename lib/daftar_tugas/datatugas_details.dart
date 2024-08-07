import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DetailsDataTugasPage extends StatefulWidget {
  final DocumentSnapshot document;

  DetailsDataTugasPage({required this.document});

  @override
  State<DetailsDataTugasPage> createState() => _DetailsDataTugasPageState();
}

class _DetailsDataTugasPageState extends State<DetailsDataTugasPage> {
  late TextEditingController namaTugas;
  late TextEditingController deskripsi;

  late String selectedPIC;
  late String selectedFrekuensi;
  late String selectedKategori;
  late String selectedStartMonth;

  bool isEditMode = false;

  List<String> picOptions = [
    'Paramedis',
    'Spv I HSSE & FS',
    'Seluruh HSSE',
    'Adm HSSE',
    'Petugas HSSE',
    'Danru Sekuriti',
    'Anggota Security',
    'ITM',
    'Seluruh Sekuriti',
    'CDO'
  ];
  List<String> frekuensiOptions = ['Mingguan', 'Bulanan', 'Tahunan'];
  List<String> kategoriOptions = [
    'HEALTH',
    'SAFETY',
    'SECURITY',
    'ENVIRONMENT'
  ];
  List<String> monthOptions = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    super.initState();
    namaTugas = TextEditingController(text: widget.document['nama_tugas']);
    deskripsi = TextEditingController(text: widget.document['deskripsi']);

    selectedPIC = widget.document['pic'] ?? picOptions[0];
    selectedFrekuensi = widget.document['frekuensi'] ?? frekuensiOptions[0];
    selectedKategori = widget.document['kategori_tugas'] ?? kategoriOptions[0];
    selectedStartMonth = widget.document['bulanMulai'] ?? '';

    validateDropdownValue();
  }

  void validateDropdownValue() {
    if (!picOptions.contains(selectedPIC)) {
      selectedPIC = picOptions[0];
    }
    if (!frekuensiOptions.contains(selectedFrekuensi)) {
      selectedFrekuensi = frekuensiOptions[0];
    }
    if (!kategoriOptions.contains(selectedKategori)) {
      selectedKategori = kategoriOptions[0];
    }
    if (!monthOptions.contains(selectedStartMonth) &&
        selectedStartMonth.isNotEmpty) {
      selectedStartMonth = monthOptions[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double setWidth = deviceWidth;

    return Scaffold(
      appBar: AppBar(title: Text('Rincian Tugas')),
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
              buildTextField('Nama Tugas', namaTugas, setWidth, isEditMode),
              buildDropdownField('PIC', selectedPIC, picOptions, isEditMode),
              buildDropdownField(
                  'Frekuensi', selectedFrekuensi, frekuensiOptions, isEditMode),
              buildDropdownField(
                  'Kategori', selectedKategori, kategoriOptions, isEditMode),
              buildDropdownField(
                  'Mulai Pada Bulan',
                  selectedStartMonth,
                  monthOptions,
                  isEditMode &&
                      selectedFrekuensi != 'Mingguan' &&
                      selectedStartMonth.isNotEmpty),
              buildTextField('Deskripsi', deskripsi, setWidth, isEditMode,
                  isMultiLine: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildButton(isEditMode ? 'Save' : 'Edit', Colors.orange,
                      _toggleEditMode),
                  buildButton('Upload', Colors.blue, _uploadDocument),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      double width, bool enabled,
      {bool isMultiLine = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(fontSize: 18)),
        ),
        SizedBox(
          height: isMultiLine ? 120 : 60,
          width: width,
          child: TextFormField(
            controller: controller,
            textAlignVertical:
                isMultiLine ? TextAlignVertical.top : TextAlignVertical.bottom,
            style: TextStyle(fontSize: 16),
            enabled: enabled,
            maxLines: isMultiLine ? 6 : 1,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdownField(
      String label, String value, List<String> options, bool enabled) {
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
          child: DropdownButtonFormField(
            value: value.isNotEmpty ? value : null,
            items: options.map((String option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: enabled
                ? (newValue) {
                    setState(() {
                      switch (label) {
                        case 'PIC':
                          selectedPIC = newValue.toString();
                        case 'Frekuensi':
                          selectedFrekuensi = newValue.toString();
                        case 'Kategori':
                          selectedKategori = newValue.toString();
                        case 'Mulai Pada Bulan':
                          selectedStartMonth = newValue.toString();
                      }
                    });
                  }
                : null,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
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
      width: 130,
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
        _saveTask();
      }
    });
  }

  Future<void> _saveTask() async {
    try {
      String nama = namaTugas.text.trim();
      String pIc = selectedPIC.trim();
      String frekuensiTugas = selectedFrekuensi.trim();
      String kategoriTugas = selectedKategori.trim();
      String bulanMulai =
          selectedFrekuensi == 'Mingguan' ? '' : selectedStartMonth.trim();
      String deskripsiTugas = deskripsi.text.trim();

      if (nama.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('data_tugas')
            .doc(widget.document.id)
            .update({
          'nama_tugas': nama,
          'pic': pIc,
          'frekuensi': frekuensiTugas,
          'kategori_tugas': kategoriTugas,
          'bulanMulai': bulanMulai,
          'deskripsi': deskripsiTugas,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data tugas berhasil diupdate!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Mohon masukkan data yang benar!'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print('Error updating task: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> _uploadDocument() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // Get the file
        PlatformFile file = result.files.first;

        // Get a reference to the storage bucket
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('documents/${file.name}');

        // Upload the file
        UploadTask uploadTask = ref.putFile(File(file.path!));

        // Wait for the upload to complete
        TaskSnapshot snapshot = await uploadTask;

        // Get the file's download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Save the file metadata to Firestore
        await FirebaseFirestore.instance.collection('documents').add({
          'name': file.name,
          'url': downloadUrl,
          'uploaded_at': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Document uploaded successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ));
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No file selected'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print('Error uploading document: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
