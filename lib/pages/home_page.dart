import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pertamina_app/daftar_tugas/datatugas_page.dart';

class HomePage extends StatefulWidget {
  final DocumentSnapshot userData;

  const HomePage({required this.userData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String today = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(200),
            child: AppBar(
                backgroundColor: Colors.blue,
                flexibleSpace: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(children: [
                        Container(
                            margin: EdgeInsets.only(top: 15),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/logo.png'),
                                    fit: BoxFit.fitHeight),
                                borderRadius: BorderRadius.circular(4.0)),
                            width: 100,
                            height: 50)
                      ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 150),
                                      child: Text(
                                          'Welcome ${widget.userData['nama_karyawan']}',
                                          style: TextStyle(fontSize: 18),
                                          overflow: TextOverflow.ellipsis)),
                                  Text(today, style: TextStyle(fontSize: 14))
                                ]),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: widget.userData[
                                                        'profile_picture'] !=
                                                    null
                                                ? NetworkImage(widget.userData[
                                                    'profile_picture'])
                                                : AssetImage(
                                                        'assets/default_profile_picture.png')
                                                    as ImageProvider,
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    width: 110,
                                    height: 120))
                          ])
                    ])))),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text('Daftar Kategori Tugas',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCard(context, 'HEALTH', Colors.orange),
                            _buildCard(context, 'SAFETY', Colors.red)
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildCard(context, 'SECURITY', Colors.blue),
                            _buildCard(context, 'ENVIRONMENT', Colors.green)
                          ]),
                      SizedBox(height: 20),
                      Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text('Daftar Tugas Bulan',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(12, (index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TugasListPage(
                                              category:
                                                  'Tasks for ${DateFormat('MMMM').format(DateTime(0, index + 1))}',
                                              month: DateFormat('MMMM').format(
                                                  DateTime(0, index + 1)),
                                              userData: widget.userData)));
                                },
                                child: Card(
                                    child: Center(
                                        child: Text(
                                            DateFormat('MMM')
                                                .format(DateTime(0, index + 1)),
                                            style: TextStyle(fontSize: 18)))));
                          }))
                    ]))));
  }

  Widget _buildCard(BuildContext context, String name, Color color) {
    return Expanded(
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TugasListPage(
                          category: name.toUpperCase(),
                          userData: widget.userData,
                          month: '')));
            },
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('data_tugas')
                    .where('kategori_tugas', isEqualTo: name)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  int totalTasks = snapshot.data!.docs.length;
                  int completedTasks = snapshot.data!.docs
                      .where((doc) => doc['status'] == 'Completed')
                      .length;
                  double progress =
                      totalTasks > 0 ? completedTasks / totalTasks : 0;

                  return Card(
                      color: color,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                                SizedBox(height: 8),
                                Text('Rancangan: $totalTasks',
                                    style: TextStyle(color: Colors.white)),
                                Text('Realisasi: $completedTasks',
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(height: 8),
                                Row(children: [
                                  Expanded(
                                      child: LinearProgressIndicator(
                                          value: progress,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.3),
                                          color: Colors.white)),
                                  SizedBox(width: 8),
                                  Text('${(progress * 100).toInt()}%',
                                      style: TextStyle(color: Colors.white))
                                ])
                              ])));
                })));
  }
}
