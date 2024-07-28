import 'package:flutter/material.dart';
import '../bottomnavbar.dart'; // Ensure to import your main file or the file where MyHomePage is defined

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo at the center top
              Container(
                width: 350,
                height: 175,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/logo.png'), // Add your logo asset here
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Text message
              Text(
                'SILAHKAN LOGIN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Username input box
              SizedBox(
                width: 300, // Adjust the width as needed
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Password input box
              SizedBox(
                width: 300, // Adjust the width as needed
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Login button
              SizedBox(
                width: 300, // Adjust the width as needed
                child: ElevatedButton(
                  onPressed: () {
                    // Add login logic here
                    if (usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => NavBar()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
