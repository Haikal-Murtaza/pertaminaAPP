import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pertamina_app/nav.dart';
import 'package:pertamina_app/user_account/login_page.dart';

class PrivacyPage extends StatefulWidget {
  @override
  _PrivacyPageState createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isObsure = true;

  Future<void> _updatePassword() async {
    String newPassword = _passwordController.text.trim();
    if (newPassword.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.updatePassword(newPassword);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Password berhasil diupdate')));

          // Sign out the user
          await FirebaseAuth.instance.signOut();

          // Navigate to the login screen
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        }
      } catch (e) {
        print('Failed to update password: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal mengupdate password')));
      }
    }
  }

  Future<void> _resetPassword() async {
    String newPassword = 'pertamina';
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Password berhasil direset')));
        // Sign out the user
        await FirebaseAuth.instance.signOut();

        // Navigate to the login screen
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));
      }
    } catch (e) {
      print('Failed to reset password: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal mereset password')));
    }
  }

  Future<void> _updateEmail() async {
    String newEmail = _emailController.text.trim();
    if (newEmail.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.verifyBeforeUpdateEmail(newEmail);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Verification email telah dikirim. Tolong konfirmasi untuk mengupdate email address anda')));
          // Sign out the user
          await FirebaseAuth.instance.signOut();

          // Navigate to the login screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } catch (e) {
        print('Failed to update email: $e');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal mengupdate email')));
      }
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Confirmation"),
              content:
                  const Text("Apakah anda yakin ingin menghapus akun anda?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteAccount();
                    },
                    child: const Text("Delete"))
              ]);
        });
  }

  Future<void> _deleteAccount() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get Firestore document reference
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection('data_karyawan')
            .doc(user.uid);
        DocumentSnapshot document = await userDoc.get();

        String profileImageUrl = document['profile_picture'] ?? '';

        // Delete the user account
        await user.delete();

        // Delete profile picture from Firebase Storage
        if (profileImageUrl.isNotEmpty) {
          await FirebaseStorage.instance.refFromURL(profileImageUrl).delete();
        }

        // Delete user data from Firestore
        await userDoc.delete();

        // Sign out the user
        await FirebaseAuth.instance.signOut();

        // Navigate to the login screen
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()));

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Akun berhasil dihapus')));
      }
    } catch (e) {
      print('Failed to delete account: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menghapus akun')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Privacy')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(children: [
              SizedBox(height: 30),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Change Email', border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: _updateEmail, child: Text('Update Email')),
              SizedBox(height: 30),
              TextField(
                  controller: _passwordController,
                  obscureText: _isObsure,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _isObsure ? Icons.visibility_off : Icons.visibility,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObsure = !_isObsure;
                            });
                          }))),
              SizedBox(height: 15),
              ElevatedButton(
                  onPressed: _updatePassword, child: Text('Ganti Password')),
              SizedBox(height: 15),
              ElevatedButton(
                  onPressed: _resetPassword, child: Text('Reset Password')),
              SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () => showDeleteConfirmationDialog(context),
                  child: Text('Delete Account'))
            ])));
  }
}
