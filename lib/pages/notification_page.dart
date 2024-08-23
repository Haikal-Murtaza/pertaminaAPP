import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  final String userRole;
  final String userId;

  NotificationsPage({required this.userRole, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Notifications')),
        body: FutureBuilder<Map<String, int>>(
            future: _getNotificationCounts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final counts = snapshot.data!;
                return ListView(
                    padding: EdgeInsets.all(16.0),
                    children: _buildNotificationWidgets(counts));
              }
            }));
  }

  Future<Map<String, int>> _getNotificationCounts() async {
    int notCompletedCount = 0;
    int needToReviewCount = 0;
    int needToApproveCount = 0;

    QuerySnapshot tasksSnapshot =
        await FirebaseFirestore.instance.collection('data_tugas').get();

    for (var doc in tasksSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final status = data['status'];

      if (status == 'Not Completed' ||
          status == 'Ask to Revise' ||
          status == 'Denied') {
        notCompletedCount++;
      } else if (status == 'Pending') {
        needToReviewCount++;
      } else if (status == 'Progress') {
        needToApproveCount++;
      }
    }

    return {
      'notCompleted': notCompletedCount,
      'needToReview': needToReviewCount,
      'needToApprove': needToApproveCount
    };
  }

  List<Widget> _buildNotificationWidgets(Map<String, int> counts) {
    List<Widget> notifications = [];

    if (userRole == 'TKJP' || userRole == 'Admin') {
      notifications.add(Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              title: Text('Not Completed Tasks'),
              subtitle: Text('${counts['notCompleted']} task(s) not completed'),
              leading: Icon(Icons.warning, color: Colors.red))));
    }

    if (userRole == 'Reviewer' || userRole == 'Admin') {
      notifications.add(Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              title: Text('Tasks Need Review'),
              subtitle: Text('${counts['needToReview']} task(s) need review'),
              leading: Icon(Icons.rate_review, color: Colors.orange))));
    }

    if (userRole == 'Approver' || userRole == 'Admin') {
      notifications.add(Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              title: Text('Tasks Need Approval'),
              subtitle:
                  Text('${counts['needToApprove']} task(s) need approval'),
              leading: Icon(Icons.check_circle, color: Colors.green))));
    }

    if (notifications.isEmpty) {
      notifications.add(Center(child: Text('No notifications available')));
    }

    return notifications;
  }
}
