import 'package:flutter/material.dart';
import 'package:pertamina_app/pages/about_page.dart';
import 'package:pertamina_app/pages/admin_page.dart';
import 'package:pertamina_app/pages/completed_task_list_page.dart';
import 'package:pertamina_app/pages/login_page.dart';
import 'package:pertamina_app/pages/notification_page.dart';
import 'package:pertamina_app/pages/privacy_page.dart';

import 'stokBarang/stok_add.dart';
import 'stokBarang/stokbrg.dart';

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
      context, MaterialPageRoute(builder: (context) => StockListPage()));
}

void navToAdd(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => AddStockPage()));
}
