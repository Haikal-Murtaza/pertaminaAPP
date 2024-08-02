import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pertamina_app/daftar_tugas/datatugas_add.dart';
import 'daftar_pekerja/datakaryawan_add.dart';
import 'daftar_pekerja/datakaryawan_page.dart';
import 'pages/about_page.dart';
import 'pages/admin_page.dart';
import 'daftar_tugas/completed_task_list_page.dart';
import 'pages/notification_page.dart';
import 'pages/privacy_page.dart';
import 'user_account/login_page.dart';

// navigation profile page
void navNotificationPage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => NotificationsPage()));
}

void navAdminPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage()));
}

void navPrivacyPage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => PrivacyPage()));
}

void navAboutPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
}

void navLogout(BuildContext context) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginPage()));
}

// navigation admin page
void navCompletedTaskPage(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => CompletedTaskListPage()));
}

void navEmployeePage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => KaryawanListPage()));
}

void navToAdd(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AddDataKaryawanPage()));
}

void navToAddTask(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AddDataTugasPage()));
}

Color maroon = Colors.red.shade900;
