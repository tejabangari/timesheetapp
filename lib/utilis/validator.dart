import 'dart:core';

class Validator{
  static String? validateEmail({required String? email}) {
    if(email == null){
      return null;

    }
    RegExp emailRegExp = RegExp(
       r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty){
      return 'Email can\'t be empty';

    }else if(! emailRegExp.hasMatch(email)){
      return 'Enter a correct email';

    }
    return null;

  }
  static String? validatePassword({
    required String? Password
  }){
    if (Password == null){
      return null;

    }
    if (Password.isEmpty) {
       return 'Password can\'t be empty';
    }else if (Password.length < 6) {
      return 'Enter a password with length at least 6';
    }
    return null;
  }
  static String? validateEmployeeid({
    required String? employeeid
  }){
    if(employeeid == null){
      return null;

    }
    if(employeeid.isEmpty){
      return 'Employeeid can\'t be empty';

    }
    return null;

  }
 static String? validateAge({
    required String? employeeage
  }){
    if(employeeage == null){
      return null;

    }
    if(employeeage.isEmpty){
      return 'Employeeage can\'t be empty';

    }
    return null;

  }

}