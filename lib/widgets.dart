import 'package:employee_timesheet/utilis/validator.dart';
import 'package:flutter/material.dart';

final _formkey = GlobalKey<FormState>();
bool _isProcessing = true;
var _category = ["Male", "Female", "Other"];
var _department = ['Development', 'Management', 'others'];
logoWidget() {
  return Image.asset(
   'assets/employee_image.png' ,
    fit: BoxFit.fitWidth,
    width: 100,
    height: 100,
  );
}
TextFormField reusableTextField(
  String text,
  IconData icon,
  bool isPasswordType,
  bool isEmailType,
  bool isEmployeeidType,
  bool isAgeType,
  TextEditingController controller,
  String value
){
  return TextFormField(
    controller: controller,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) => isPasswordType
    ?Validator.validatePassword(Password: value)
    :(isEmailType? Validator.validateEmail(email: value)
    :(isAgeType
    ? Validator.validateAge( employeeage: 'value')
    :Validator.validateEmployeeid(employeeid:value))
    ),
    obscureText: isPasswordType,
    enableSuggestions:!isPasswordType ,
    autocorrect: !isPasswordType,
    cursorColor: Colors.grey,
    textInputAction: isPasswordType? TextInputAction.done : TextInputAction.next,
    onSaved: (value) => value = value,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.red,
      ),
       labelText: text,
      labelStyle: TextStyle(
        color: Colors.blue.withOpacity(0.9),
      ),
       filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.blue.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
        
  );
}
Widget button(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
    ),
     child: ElevatedButton(
      onPressed: () {
        showLoaderDialog(context);

        onTap();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.blue;
          }
          return Colors.blue;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}
showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Loading...")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
dropDown(context, String labelText, List<String> itemsList, IconData icon,
    value, onChanged) {
  return Container(
    child: FormField(
      enabled: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<dynamic> field) {
        return InputDecorator(
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.black,
            ),
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.black.withOpacity(0.3),
            contentPadding: const EdgeInsets.only(top: 10.0, bottom: 0.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide:
                    const BorderSide(width: 0, style: BorderStyle.none)),
            errorText: field.errorText,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              dropdownColor: Colors.transparent,
              isExpanded: true,
              value: value,
              onChanged: onChanged,

              items: itemsList.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(
                    "$option",
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              }).toList(),
              // value: field.value,
            ),
          ),
        );
      },
    ),
  );
}

