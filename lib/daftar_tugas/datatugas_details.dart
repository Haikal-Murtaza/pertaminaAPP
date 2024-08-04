import 'package:cloud_firestore/cloud_firestore.dart';
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
    selectedPIC = widget.document['pic'];
    selectedFrekuensi = widget.document['frekuensi'];
    selectedKategori = widget.document['kategori_tugas'];
    selectedStartMonth = widget.document['bulanMulai'] ?? 'January';
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
              buildTextField('Nama Tugas', namaTugas, setWidth, false),
              buildDropdownField('PIC', selectedPIC, picOptions, false),
              buildDropdownField(
                  'Frekuensi', selectedFrekuensi, frekuensiOptions, false),
              buildDropdownField(
                  'Kategori', selectedKategori, kategoriOptions, false),
              buildDropdownField('Mulai Pada Bulan', selectedStartMonth,
                  monthOptions, selectedFrekuensi != 'Mingguan'),
              buildTextField('Deskripsi', deskripsi, setWidth, false,
                  isMultiLine: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildButton('Edit', Colors.orange, _editTask),
                  buildButton('Upload Document', Colors.blue, _uploadDocument),
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
            value: value,
            items: options.map((String option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: enabled
                ? (newValue) {
                    setState(() {
                      value = newValue.toString();
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

  void _editTask() {
    // Implement edit task functionality
  }

  void _uploadDocument() {
    // Implement document upload functionality
  }
}
