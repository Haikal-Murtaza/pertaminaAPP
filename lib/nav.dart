import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pertamina_app/daftar_hadir/qr_generate_page.dart';
import 'package:pertamina_app/daftar_pekerja/datakaryawan_attandee.dart';
import 'package:pertamina_app/daftar_pekerja/datakaryawan_details.dart';
import 'package:pertamina_app/daftar_tugas/datatugas_details.dart';
import 'package:pertamina_app/daftar_tugas/approve_task_list_page.dart';
import 'package:pertamina_app/daftar_tugas/review_task_list_page.dart';
import 'package:pertamina_app/daftar_tugas/uploaded_docs_task_page.dart';
import 'daftar_pekerja/datakaryawan_add.dart';
import 'daftar_pekerja/datakaryawan_list_page.dart';
import 'daftar_tugas/datatugas_add.dart';
import 'pages/about_page.dart';
import 'pages/other_page.dart';
import 'daftar_tugas/completed_task_list_page.dart';
import 'pages/notification_page.dart';
import 'user_account/privacy_page.dart';
import 'user_account/login_page.dart';

// navigation profile page
void navNotificationPage(BuildContext context, String userRole, userId) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              NotificationsPage(userRole: userRole, userId: userId)));
}

void navOtherPage(BuildContext context, DocumentSnapshot userData) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => OtherPage(userData: userData)));
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

void navToAddTask(BuildContext context, String userName) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddDataTugasPage(
                userName: userName,
              )));
}

void navToDetailsTask(
    BuildContext context, DocumentSnapshot<Object?> documentTasks, userData) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailsDataTugasPage(
              documentTasks: documentTasks, userData: userData)));
}

void navToDoc(
    BuildContext context, DocumentSnapshot<Object?> documentTask, int value) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              UploadedDocsPage(documentTask: documentTask, value: value)));
}

void navEmployeePage(BuildContext context, DocumentSnapshot<Object?> userData) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => KaryawanListPage(userData: userData)));
}

void navToAdd(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AddDataKaryawanPage()));
}

void navToDetailsKaryawan(
    BuildContext context, DocumentSnapshot<Object?> documentUsers) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              DetailsDataKaryawanPage(documentUsers: documentUsers)));
}

void navToAttendeeData(
    BuildContext context, DocumentSnapshot<Object?> documentUsers) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              KaryawanAttandeeData(documentUsers: documentUsers)));
}

void navGenQR(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => QrCodeGeneratorPage()));
}

Color maroon = Colors.red.shade900;
