import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:pertamina_app/nav.dart';
import 'dart:convert';
import '../bottomnavbar.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObsure = true;

  Future<void> _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Tolong isi username dan password');
      return;
    }

    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('data_karyawan')
          .where('username', isEqualTo: username)
          .get();

      if (userQuery.docs.isEmpty) {
        _showErrorDialog('User not found');
        return;
      }

      var userData = userQuery.docs.first.data() as Map<String, dynamic>;
      String storedHashedPassword = userData['password'];

      if (_hashPassword(password) == storedHashedPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NavBar()),
        );
      } else {
        _showErrorDialog('Password tidak sesuai');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.topCenter,
      child: Column(children: [
        // Logo at the center top
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
        // Username input box
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
                        controller: usernameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.black,
                            hintText: 'Username',
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.account_circle_outlined,
                      size: 35, weight: 0.5),
                )
              ],
            )),
        SizedBox(height: 20),
        // Password input box
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
        // Login button
        SizedBox(
            width: 300,
            height: 55,
            child: ElevatedButton(
                onPressed: _login,
                style: ButtonStyle(
                    shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    backgroundColor: WidgetStatePropertyAll(maroon)),
                child: Text('Login',
                    style: TextStyle(fontSize: 18, color: Colors.white)))),
      ]),
    ));
  }
}
