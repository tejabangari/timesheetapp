
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:employee_timesheet/model/user_model.dart';
 class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> profileDetails({
     required String name,
    required int age,
    required String selectGender,
    required String selectDepartment,
    required String imageUrl,
    required String uid,
    required String email,
    required String password,
   
  })
  async{
    String resp = 'Some error occured';
    try{
      if(email.isNotEmpty || password.isNotEmpty || name.isNotEmpty){
        UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        UserData userData =  UserData(
          name: name,age: age,selectGender: selectGender,selectDepartment: selectDepartment
        );
        await _firestore.collection('profileDetails').doc(credential.user!.uid).set(userData.toJson());

      }

    }catch(err){
      resp = err.toString();

    }return resp;

  }
  Future<String> loginUser({
    required String email,
    required String password,

  }) async {
    String res = 'some error occured';
    try{
      if(email.isNotEmpty|| password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'sucess';
      }

    }catch(err){
      res = err.toString();

    }
    return res;
  }
  Future<String>registerUser({
    required String email,
    required String employeeid,
    required String password,
  })
  async{
    String resp ='Some error occured';
    try{
      if(email.isNotEmpty|| password.isNotEmpty|| employeeid.isNotEmpty){
        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        resp = 'sucess';

      }
    }catch(err){
      resp = err.toString();

    }
    return resp;
  }
 }










// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:employee_timesheet/model/user_model.dart';
//  class AuthMethods{
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<String> profileDetails({
//      required String name,
//     required int age,
//     required String selectGender,
//     required String selectDepartment,
//     required String imageUrl,
//     required String uid,
//     required String email,
//     required String password,
//   })
//   async{
//     String resp = 'Some error occured';
//     try{
//       if(email.isNotEmpty || password.isNotEmpty || name.isNotEmpty){
//         UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//         UserData userData =  UserData(
//           name: name,age: age,selectGender: selectGender,selectDepartment: selectDepartment
//         );
//         await _firestore.collection('profileDetails').doc(credential.user!.uid).set(userData.toJson());

//       }

//     }catch(err){
//       resp = err.toString();

//     }return resp;

//   }
//   Future<String> login
//  }