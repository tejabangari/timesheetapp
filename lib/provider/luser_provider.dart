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
  String? age;
  String? selectGender;
  String? selectDepartment;
  String? imageUrl;
  PickedFile? _imageFile;
  PickedFile? get imageFile => _imageFile;

  final ImagePicker _picker = ImagePicker();

  ProviderState(
      {this.name, this.age, this.selectGender, this.selectDepartment});
  TextEditingController ageController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<void> storeData(
    String name,
    String age,
    String? selectGender,
    String? selectDepartment,
  ) async {
    User? user = await FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('profileDetails').doc(user?.uid).set(
      {
        'name': name,
        'age': age,
        'gender': selectGender,
        'department': selectDepartment,
      },
    );
    if (_imageFile != null) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref();
      Reference refDirImages = ref.child('profileImages');
      Reference refImageToUpload = refDirImages.child(uniqueFileName);
      try {
        await refImageToUpload.putFile(File(_imageFile!.path));
        imageUrl = await refImageToUpload.getDownloadURL();
      } catch (error) {
        print(error.toString());
      }
    }
    // Update the values in the ProviderState instance
    this.name = name;
    this.age = age;
    this.selectGender = selectGender;
    this.selectDepartment = selectDepartment;

    notifyListeners();
  }

  Future<void> getData() async {
    User? user = await FirebaseAuth.instance.currentUser!;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('profileDetails')
        .doc(user.uid)
        .get();
    if (doc.data() != null) {
      Map<String, dynamic> details = doc.data() as Map<String, dynamic>;
      nameController.text = details['name'];
      ageController.text = details['age'];
      selectGender = details['gender'];
      selectDepartment = details['department'];
    }
    notifyListeners();
  }

  Future<void> getImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _imageFile = pickedFile;
        notifyListeners();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
}

// Future<void> getImage() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.getImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//          _imageFile = File(pickedFile.path) as PickedFile?;
//         notifyListeners();
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }
// }


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





// Future<void> storeData(
  //   name,age,selectGender,selectDepartment
  // )async{
  //   User? user = await FirebaseAuth.instance.currentUser;
  //   FirebaseFirestore.instance.collection('profileDetails').doc(user?.uid).set(
  //     {
  //       'name': name,
  //       'age':age,
  //       'gender':selectGender,
  //       'department':selectDepartment
  //     }
  //   );
  //   notifyListeners();

  // }

