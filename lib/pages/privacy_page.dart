import 'package:flutter/material.dart';
import 'dart:io';

class PrivacyPage extends StatefulWidget {
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;

  // final picker = ImagePicker();

  Future<void> _updateProfilePicture() async {
    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     _image = File(pickedFile.path);
    //   });

    //   // Upload new profile picture to Firebase Storage and update user document in Firestore
    //   // (Assume the function _uploadProfilePicture handles the upload and update)
    //   await _uploadProfilePicture(_image!);
    // }
  }

  Future<void> _uploadProfilePicture(File image) async {
    // Implement upload logic here
  }

  Future<void> _updateUsername() async {
    String newUsername = _usernameController.text.trim();
    if (newUsername.isNotEmpty) {
      // Update username in Firestore
      // User? user = FirebaseAuth.instance.currentUser;
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user?.uid)
      //     .update({'username': newUsername});
    }
  }

  Future<void> _updatePassword() async {
    String newPassword = _passwordController.text.trim();
    if (newPassword.isNotEmpty) {
      // Update password in Firebase Authentication
      // User? user = FirebaseAuth.instance.currentUser;
      // await user?.updatePassword(newPassword);
    }
  }

  Future<void> _updateEmail() async {
    String newEmail = _emailController.text.trim();
    if (newEmail.isNotEmpty) {
      // Update email in Firebase Authentication
      // User? user = FirebaseAuth.instance.currentUser;
      // await user?.updateEmail(newEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: _updateProfilePicture,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : AssetImage('assets/default_profile_picture.png')
                          as ImageProvider,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Change Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateUsername,
              child: Text('Update Username'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Change Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updatePassword,
              child: Text('Update Password'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Change Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _updateEmail,
              child: Text('Update Email'),
            ),
          ],
        ),
      ),
    );
  }
}
