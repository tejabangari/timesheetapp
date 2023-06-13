import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_timesheet/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../utilis/fire_auth.dart';
import '../utilis/validator.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _signupFormKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();

  final _focusEmail = FocusNode();

  bool _isProcessing = false;
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Employee Details'),
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset('assets/employee image.png'),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Sign Up',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            Form(
              key: _signupFormKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailTextController,
                      focusNode: _focusEmail,
                      validator: (value) => Validator.validateEmail(
                        email: value,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        hintText: 'Enter Your Email',
                        labelText: 'Email',
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    _isProcessing
                        ? CircularProgressIndicator()
                        : TextButton(
                            onPressed: (() async {
                              FirebaseAuth.instance
                                  .sendPasswordResetEmail(
                                      email: _emailTextController.text)
                                  .then((value) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              });
                            }),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(),
                            ),
                          ),
                  ]),
            ),
          ]),
        ),
      ),
    );
  }
}
