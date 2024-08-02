import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AddDataKaryawanPage extends StatefulWidget {
  @override
  State<AddDataKaryawanPage> createState() => _AddDataKaryawanPageState();
}

class _AddDataKaryawanPageState extends State<AddDataKaryawanPage> {
  final TextEditingController namakaryawan = TextEditingController();
  final TextEditingController nipkaryawan = TextEditingController();
  final TextEditingController emailkaryawan = TextEditingController();
  final TextEditingController jabatankaryawan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double setWidth = deviceWidth * 0.55;

    return Scaffold(
        appBar: AppBar(title: Text('Tambah Data Karyawan')),
        body: Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: 500,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 0, blurRadius: 4, offset: Offset(0, 1))
                ]),
            child: Column(children: [
              Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: Text('Nama karyawan',
                            style: TextStyle(fontSize: 15))),
                    Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: Text('NIP karyawan',
                            style: TextStyle(fontSize: 15))),
                    Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: Text('Email Karyawan',
                            style: TextStyle(fontSize: 15))),
                    Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: Text('Jabatan/Bagian',
                            style: TextStyle(fontSize: 15))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: Text(' :  ', style: TextStyle(fontSize: 15))),
                    Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: Text(' :  ', style: TextStyle(fontSize: 15))),
                    Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: Text(' :  ', style: TextStyle(fontSize: 15))),
                    Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        child: Text(' :  ', style: TextStyle(fontSize: 15))),
                  ],
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                      height: 60,
                      width: setWidth,
                      child: TextFormField(
                        controller: namakaryawan,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 16),
                      )),
                  SizedBox(
                      height: 60,
                      width: setWidth,
                      child: TextFormField(
                        controller: nipkaryawan,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 16),
                      )),
                  SizedBox(
                      height: 60,
                      width: setWidth,
                      child: TextFormField(
                        controller: emailkaryawan,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 16),
                      )),
                  SizedBox(
                      height: 60,
                      width: setWidth,
                      child: TextFormField(
                        controller: jabatankaryawan,
                        textAlignVertical: TextAlignVertical.bottom,
                        style: TextStyle(fontSize: 16),
                      )),
                ])
              ]),
              Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.grey.shade700)),
                  child: GestureDetector(
                      onTap: () {
                        _addKaryawan(context);
                      },
                      child: Center(
                          child: Text('Add',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))))
            ])));
  }

  void _addKaryawan(BuildContext context) async {
    try {
      String nama = namakaryawan.text.trim();
      String nip = nipkaryawan.text.trim();
      String email = emailkaryawan.text.trim();
      String jabatan = jabatankaryawan.text.trim();

      if (nama.isNotEmpty) {
        await FirebaseFirestore.instance.collection('data_karyawan').add({
          'nama_karyawan': nama,
          'nip_karyawan': nip,
          'email_karyawan': email,
          'jabatan_karyawan': jabatan,
          'password': hashPassword('pertamina'),
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data Karyawan berhasil ditambahkan!'),
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

String hashPassword(String password) {
  final bytes = utf8.encode(password); // Convert password to bytes
  final digest = sha256.convert(bytes); // Hash the password
  return digest.toString(); // Return the hashed password as a string
}
