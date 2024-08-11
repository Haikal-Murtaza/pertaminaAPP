import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDataTugasPage extends StatefulWidget {
  @override
  State<AddDataTugasPage> createState() => _AddDataTugasPage();
}

class _AddDataTugasPage extends State<AddDataTugasPage> {
  final TextEditingController namaTugas = TextEditingController();
  final TextEditingController deskripsi = TextEditingController();

  String selectedPIC = 'Paramedis';
  String selectedFrekuensi = 'Mingguan';
  String selectedKategori = 'HEALTH';
  String selectedStartMonth = 'January';

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
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double setWidth = deviceWidth;

    return Scaffold(
        appBar: AppBar(title: Text('Tambah Tugas')),
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
                  buildTextField('Nama Tugas', namaTugas, setWidth),
                  buildDropdownField('PIC', selectedPIC, picOptions),
                  buildDropdownField(
                      'Frekuensi', selectedFrekuensi, frekuensiOptions),
                  buildDropdownField(
                      'Kategori', selectedKategori, kategoriOptions),
                  buildDropdownField('Mulai Pada Bulan', selectedStartMonth,
                      monthOptions, selectedFrekuensi == 'Mingguan'),
                  buildTextField('Deskripsi', deskripsi, setWidth,
                      isMultiLine: true),
                  buildButton('Add', Colors.grey, _addTugas)
                ]))));
  }

  Widget buildTextField(
      String label, TextEditingController controller, double width,
      {bool isMultiLine = false}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              textAlignVertical: isMultiLine
                  ? TextAlignVertical.top
                  : TextAlignVertical.bottom,
              style: TextStyle(fontSize: 16),
              maxLines: isMultiLine ? 6 : 1,
              decoration: InputDecoration(border: OutlineInputBorder())))
    ]);
  }

  Widget buildDropdownField(String label, String value, List<String> options,
      [bool isDisabled = false]) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          height: 60,
          alignment: Alignment.centerLeft,
          child: Text(label, style: TextStyle(fontSize: 18))),
      SizedBox(
          height: 60,
          child: DropdownButtonFormField(
              value: value,
              items: options.map((String option) {
                return DropdownMenuItem(value: option, child: Text(option));
              }).toList(),
              onChanged: isDisabled
                  ? null
                  : (newValue) {
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

  void _addTugas(BuildContext context) async {
    try {
      String nama = namaTugas.text.trim();
      String pIc = selectedPIC.trim();
      String frekuensiTugas = selectedFrekuensi.trim();
      String kategoriTugas = selectedKategori.trim();
      String bulanMulai =
          selectedFrekuensi == 'Mingguan' ? '' : selectedStartMonth.trim();
      String deskripsiTugas = deskripsi.text.trim();

      if (nama.isNotEmpty) {
        await FirebaseFirestore.instance.collection('data_tugas').add({
          'nama_tugas': nama,
          'pic': pIc,
          'frekuensi': frekuensiTugas,
          'kategori_tugas': kategoriTugas,
          'bulanMulai': bulanMulai,
          'deskripsi': deskripsiTugas,
          'status': 'Not Completed',
          'uploadDocument': {
            'name': '',
            'url': '',
            'filePath': ''
          } 
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Data tugas berhasil ditambahkan!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4)));
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Mohon masukkan data yang benar!'),
            duration: Duration(seconds: 2)));
      }
    } catch (e) {
      print('Error adding task: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred. Please try again later.'),
          duration: Duration(seconds: 2)));
    }
  }
}
