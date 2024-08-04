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
            BoxShadow(spreadRadius: 0, blurRadius: 4, offset: Offset(0, 1))
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text('Nama Tugas', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 60,
                width: setWidth,
                child: TextFormField(
                  controller: namaTugas,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text('PIC', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 60,
                width: setWidth,
                child: DropdownButtonFormField(
                  value: selectedPIC,
                  items: picOptions.map((String pic) {
                    return DropdownMenuItem(
                      value: pic,
                      child: Text(pic),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedPIC = newValue.toString();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text('Frekuensi', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 60,
                width: setWidth,
                child: DropdownButtonFormField(
                  value: selectedFrekuensi,
                  items: frekuensiOptions.map((String frekuensi) {
                    return DropdownMenuItem(
                      value: frekuensi,
                      child: Text(frekuensi),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedFrekuensi = newValue.toString();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text('Kategori', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 60,
                width: setWidth,
                child: DropdownButtonFormField(
                  value: selectedKategori,
                  items: kategoriOptions.map((String kategori) {
                    return DropdownMenuItem(
                      value: kategori,
                      child: Text(kategori),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedKategori = newValue.toString();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text('Mulai Pada Bulan', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 60,
                width: setWidth,
                child: DropdownButtonFormField(
                  value: selectedStartMonth,
                  items: monthOptions.map((String month) {
                    return DropdownMenuItem(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: selectedFrekuensi == 'Mingguan'
                      ? null
                      : (newValue) {
                          setState(() {
                            selectedStartMonth = newValue.toString();
                          });
                        },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text('Deskripsi', style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: 120,
                width: setWidth,
                child: TextFormField(
                  controller: deskripsi,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: 6,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(horizontal: 8),
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.grey.shade700),
                ),
                child: GestureDetector(
                  onTap: () {
                    _addKaryawan(context);
                  },
                  child: Center(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addKaryawan(BuildContext context) async {
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
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data tugas berhasil ditambahkan!'),
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
      print('Error adding stock: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
