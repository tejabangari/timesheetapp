import 'package:employee_timesheet/provider/luser_provider.dart';
import 'package:employee_timesheet/screens/sheet_display.dart';
// import 'package:employee_timesheet/screens/time_sheet_display.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../utilis/validator.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimeTrackerScreen extends StatefulWidget {
  @override
  _TimeTrackerScreenState createState() => _TimeTrackerScreenState();
}

class _TimeTrackerScreenState extends State<TimeTrackerScreen> {
  DateTime? loginTime;
  DateTime? logoutTime;
  DateTime? selectedDate;
  final descriptionController = TextEditingController();
  late User user;
  String username = '';

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((value) {
      FirebaseAuth.instance.authStateChanges().listen((User? currentUser) {
        setState(() {
          user = currentUser!;
          _loadUsername();
        });
      });
    });
  }

  void _loadUsername() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          username = docSnapshot.data()!['username'];
        });
      }
    });
  }

  void _pickLoginTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        loginTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _pickLogoutTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        logoutTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _saveData() {
    String? descriptionError = Validator.validateDescription(
      descriptionController.text,
      description: 'Description',
    );
    String? loginTimeError = Validator.validateLoginTime(loginTime);
    String? logoutTimeError = Validator.validateLogoutTime(logoutTime);
    String? selectedDateError = Validator.validateSelectedDate(selectedDate);

    if (descriptionError != null ||
        loginTimeError != null ||
        logoutTimeError != null ||
        selectedDateError != null) {
      // Display the validation error messages
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            descriptionError ??
                loginTimeError ??
                logoutTimeError ??
                selectedDateError!,
          ),
        ),
      );
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('timesheet')
        .add({
      'loginTime': loginTime,
      'logoutTime': logoutTime,
      'selectedDate': selectedDate,
      'description': descriptionController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully')),
      );

      if (loginTime != null && logoutTime != null && selectedDate != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Time Sheet Update'),
              content: const Text(
                  'Time sheet is already updated. Do you want to make changes again?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    // Navigate to TimeSheetDisplayScreen after saving the data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => TimeSheetDisplayScreen(
                        //   timeSheetData: [
                        //     {
                        //       'loginTime': loginTime,
                        //       'logoutTime': logoutTime,
                        //       'selectedDate': selectedDate,
                        //       'description': descriptionController.text,
                        //     },
                        //   ],
                        //   selectedDate: selectedDate!,
                        //   userId: user.uid,
                        // ),
                        builder: (context) =>
                            UserTimeSheetScreen(userId: user.uid),
                      ),
                    );
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      } else {
        // Navigate to TimeSheetDisplayScreen after saving the data
        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (context) => TimeSheetDisplayScreen(
            //   timeSheetData: [
            //     {
            //       'loginTime': loginTime,
            //       'logoutTime': logoutTime,
            //       'selectedDate': selectedDate,
            //       'description': descriptionController.text,
            //     },
            //   ],
            //   selectedDate: selectedDate!,
            //   userId: user.uid,
            // ),
            builder: (context) => UserTimeSheetScreen(userId: user.uid),
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save data: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
    final DateFormat timeFormat = DateFormat('hh:mm a');

    final DateTime now = DateTime.now();
    final String formattedDate = dateFormat.format(selectedDate ?? now);

    return Scaffold(
      appBar: AppBar(
        title:  Text('Welcome $username'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/employee_image.png',
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              Flexible(
                child: TextFormField(
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Selected Date',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  controller: TextEditingController(
                    text: selectedDate != null
                        ? dateFormat.format(selectedDate!)
                        : '',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Description',
                    labelText: 'Description',
                    hintMaxLines: 5,
                    prefixIcon: Icon(Icons.notes),
                  ),
                  controller: descriptionController,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                formattedDate,
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.black,
                ),
                onPressed: _pickLoginTime,
                child: const Text('Pick Login Time'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onPrimary: Colors.black,
                ),
                onPressed: _pickLogoutTime,
                child: const Text('Pick Logout Time'),
              ),
              const SizedBox(height: 20),
              Text(
                'Login Time: ${loginTime != null ? timeFormat.format(loginTime!) : 'Not set'}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                'Logout Time: ${logoutTime != null ? timeFormat.format(logoutTime!) : 'Not set'}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.red,
                ),
                onPressed: _saveData,
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              const SizedBox(height: 30),
              BottomAppBar(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today),
                        iconSize: 30,
                      ),
                      IconButton(
                        onPressed: _pickLoginTime,
                        icon: const Icon(Icons.access_time),
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
