// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class UserData{
//   final String? name;
//   int? age;
//   String? selectGender;
//   String? selectDepartment;
//  UserData({this.name, this.age, this.selectGender, this.selectDepartment});

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'age': age,
//       'gender': selectGender,
//       'department': selectDepartment
//     };
//   }

//   static UserData fromMap(Map<String, dynamic> map) {
//     return UserData(
//         name: map['name'],
//         age: map['age'],
//         selectGender: map['gender'],
//         selectDepartment: map['department']);
//   }
  
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserData{
  final String? name;
  int? age;
  String? selectGender;
  String? selectDepartment;
 UserData({this.name, this.age, this.selectGender, this.selectDepartment});
 

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': selectGender,
      'department': selectDepartment
    };
  }

 UserData fromMap(Map<String, dynamic> map) {
    return UserData(
        name: map['name'],
        age: map['age'],
        selectGender: map['gender'],
        selectDepartment: map['department']);
  }
  
}