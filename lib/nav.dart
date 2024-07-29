import 'package:flutter/material.dart';

import 'daftar_pekerja/AddDataKaryawan.dart';
import 'daftar_pekerja/DataKaryawan.dart';
import 'pages/about_page.dart';
import 'pages/admin_page.dart';
import 'pages/completed_task_list_page.dart';
import 'pages/login_page.dart';
import 'pages/notification_page.dart';
import 'pages/privacy_page.dart';

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
