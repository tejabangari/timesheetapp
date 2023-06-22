
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserTimeSheetScreen extends StatelessWidget {
  final String userId;

  const UserTimeSheetScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Time Sheet'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('timesheet')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<DocumentSnapshot> documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return Center(
              child: Text('No time sheet data available.'),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal ,
            child: DataTable(
              columns: [
                DataColumn(
                  label: Text('Date'),
                ),
                DataColumn(
                  label: Text('Login Time'),
                ),
                DataColumn(
                  label: Text('Logout Time'),
                ),
                DataColumn(
                  label: Text('Working Hours'),
                ),
                DataColumn(
                  label: Text('Description'),
                ),
              ],
              rows: documents.map((document) {
                final Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
          
                final DateTime? loginTime =
                    data['loginTime']?.toDate() as DateTime?;
                final DateTime? logoutTime =
                    data['logoutTime']?.toDate() as DateTime?;
                final DateTime? selectedDate =
                    data['selectedDate']?.toDate() as DateTime?;
                final String description = data['description'] as String;
                final workingHours =
                    _calculateWorkingHours(loginTime, logoutTime);
                final formattedDate = DateFormat('EEEE, d MMMM yyyy')
                    .format(selectedDate ?? DateTime.now());
                final formattedLoginTime =
                    DateFormat('hh:mm a').format(loginTime ?? DateTime.now());
                final formattedLogoutTime = DateFormat('hh:mm a')
                    .format(logoutTime ?? DateTime.now());
          
                return DataRow(
                  cells: [
                    DataCell(Text(formattedDate)),
                    DataCell(Text(formattedLoginTime)),
                    DataCell(Text(formattedLogoutTime)),
                    DataCell(Text(workingHours)),
                    DataCell(Text(description)),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  String _calculateWorkingHours(DateTime? loginTime, DateTime? logoutTime) {
    if (loginTime == null || logoutTime == null) {
      return 'N/A';
    }

    final difference = logoutTime.difference(loginTime);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    return '$hours h $minutes m';
  }
}
