import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pertamina_app/bottomnavbar.dart';
import 'package:pertamina_app/nav.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObsure = true;

  Future<void> _login() async {
    String email = emailController.text;
    String password = hashPassword(passwordController.text);

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Tolong isi email dan password');
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('data_karyawan')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          String name = userData['nama_karyawan'];
          String role = userData['role'];

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavBar(name: name, role: role)));
        } else {
          _showErrorDialog(
              'User data not found in Firestore for UID: ${user.uid}');
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth errors
      if (e.code == 'user-not-found') {
        _showErrorDialog('User tidak ditemukan.');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog('Password salah');
      } else {
        _showErrorDialog('Firebase Auth Error: ${e.message}');
      }
    } catch (e) {
      // Handle other errors
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Error'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'))
              ]);
        });
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.topCenter,
            child: Column(children: [
              Container(
                  margin: EdgeInsets.only(top: 60),
                  width: 250,
                  height: 175,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/logo.png'),
                          fit: BoxFit.contain))),
              SizedBox(height: 20),
              Text('SILAHKAN LOGIN',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Container(
                  width: 300,
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 5))
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 250,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.black,
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                            color: Colors.black))))),
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.email_outlined, size: 35))
                      ])),
              SizedBox(height: 20),
              Container(
                  width: 300,
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0, 5))
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: 250,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: TextFormField(
                                    controller: passwordController,
                                    obscureText: _isObsure,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        fillColor: Colors.black,
                                        hintText: 'Password',
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                            color: Colors.black))))),
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isObsure = !_isObsure;
                                  });
                                },
                                child: Icon(
                                    _isObsure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    size: 35)))
                      ])),
              SizedBox(height: 25),
              SizedBox(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                      onPressed: _login,
                      style: ButtonStyle(
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                          backgroundColor: WidgetStateProperty.all(Colors.red)),
                      child: Text('Login',
                          style: TextStyle(fontSize: 18, color: Colors.white))))
            ])));
  }
}
