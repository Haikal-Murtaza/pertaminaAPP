// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../bottomnavbar.dart';
import '../nav.dart'; // Ensure to import your main file or the file where MyHomePage is defined

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isObsure = true;

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
                onPressed: () {
                  if (usernameController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => NavBar()));
                  }
                },
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
