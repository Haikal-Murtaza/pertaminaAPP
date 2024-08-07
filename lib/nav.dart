import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pertamina_app/daftar_pekerja/datakaryawan_details.dart';
import 'package:pertamina_app/daftar_tugas/datatugas_details.dart';
import 'package:pertamina_app/pages/approve_task_list_page.dart';
import 'package:pertamina_app/pages/review_task_list_page.dart';
import 'daftar_pekerja/datakaryawan_add.dart';
import 'daftar_pekerja/datakaryawan_page.dart';
import 'daftar_tugas/datatugas_add.dart';
import 'pages/about_page.dart';
import 'pages/admin_page.dart';
import 'pages/completed_task_list_page.dart';
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

void navApproveTaskPage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ApproveTaskListPage()));
}

void navReviewTaskPage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => ReviewTaskListPage()));
}

void navEmployeePage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => KaryawanListPage()));
}

void navToAdd(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AddDataKaryawanPage()));
}

void navToDetailsKaryawan(
    BuildContext context, DocumentSnapshot<Object?> document) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailsDataKaryawanPage(document: document)));
}

void navToAddTask(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AddDataTugasPage()));
}

void navToDetailsTask(
    BuildContext context, DocumentSnapshot<Object?> document) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailsDataTugasPage(document: document)));
}

Color maroon = Colors.red.shade900;
