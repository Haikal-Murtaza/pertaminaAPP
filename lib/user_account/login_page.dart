import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pertamina_app/navbar.dart';
import 'package:pertamina_app/nav.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObsure = true;
  DocumentSnapshot? userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Container(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.red)),
                          child: Text('Login',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white)))),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: _resetPassword,
                      child: Text('Forgot Password?',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              decoration: TextDecoration.underline)))
                ]))));
  }

  Future<void> _login() async {
    String email = emailController.text;
    String password = passwordController.text;

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
          userData = userDoc;

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => NavBar(userData: userData!)));
        } else {
          _showErrorDialog('User: ${user.uid} tidak ditemukan');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog('User tidak ditemukan.');
      } else if (e.code == 'wrong-password') {
        _showErrorDialog('Password salah');
      } else {
        _showErrorDialog('Firebase Auth Error: ${e.message}');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  Future<void> _resetPassword() async {
    String email = emailController.text;
    if (email.isEmpty) {
      _showErrorDialog('Tolong isi email untuk reset password');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccessDialog('Link reset password telah dikirim ke $email');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showErrorDialog('User tidak ditemukan.');
      } else {
        _showErrorDialog('Error: ${e.message}');
      }
    } catch (e) {
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

  void _showSuccessDialog(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Success'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'))
              ]);
        });
  }
}
