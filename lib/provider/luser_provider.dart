import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_timesheet/utilis/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProviderState extends ChangeNotifier {

 User? user;
  String? name;
  int? age;
  String? selectGender;
  String? selectDepartment;
  
  ProviderState({this.name, this.age, this.selectGender, this.selectDepartment});

  Future<void> storeData()async{
    User? user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('profileDetails').doc(user?.uid).set(
      {
        'name': name,
        'age':age,
        'gender':selectGender,
        'department':selectDepartment
      }
    );
    notifyListeners();

  }
 Future<void> getData(String? name, int? age, String? selectGender, String? selectDepartment) async {
    User? user = await FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .get();
        if(doc.data() != null){
    Map<String, dynamic> details = doc.data() as Map<String, dynamic> ;
    name = details['name'];
    age = details['age'];
    selectGender = details['gender'];
    selectDepartment = details['department'];
        }
        notifyListeners();
  }

}




//   final formkey = GlobalKey<FormState>();
//   final signupFormKey = GlobalKey<FormState>();
//   final detailsFormKey = GlobalKey<FormState>();

//   final List<String> Gender = ['male', 'Female', 'Other'];
//   final List<String> Department = ['Development', 'Management', 'CXO Team'];

//   final emailTextController = TextEditingController();
//   final passwordTextController = TextEditingController();
//   final EmployeeIdTextController = TextEditingController();
//   final nameTextController = TextEditingController();
//   final ageController = TextEditingController();
//   final departmentController = TextEditingController();

//   final ImagePicker picker = ImagePicker();
//   var selectGender;
//   var selectDepartment;

//  bool isSendingVerification = false;
//   bool  isSigningOut = false;
//       User?  currentUser ;



//   String? imageUrl;
//   final focusEmail = FocusNode();
//   final focusPassword = FocusNode();
//   final focusEmployeeId = FocusNode();
//   bool isProcessing = false;
//   bool load = false;

//   Future<User?> loginwithFirebase() async {
//     User? user = await FireAuth.signInUsingEmailPassword(
//       email: emailTextController.text,
//       password: passwordTextController.text,
//     );
//     return user;
//   }

//   Future<User?> signupwithFirebase() async {
//     User? user = await FireAuth.signUpUsingEmailPassword(
//       email: emailTextController.text,
//       Password: passwordTextController.text,
//       employeeId: EmployeeIdTextController.text,
//     );
//     return user;
//   }

//   Future<User?> getProfileDetails() async {
//     CollectionReference ProfileDetails =
//         FirebaseFirestore.instance.collection('profileDetails');
//     var widget;
//     final result = await ProfileDetails.doc(widget.user.uid).get();
//     if (result.data() != null) {
//       Map<String, dynamic> details = result.data() as Map<String, dynamic>;
//       nameTextController.text = details['name'];
//       ageController.text = details['age'].toString();
//       selectGender = details['gender'];
//       selectDepartment = details['department'];
//       imageUrl = details['imageLink'];
//       return currentUser;
//     }
//   }



