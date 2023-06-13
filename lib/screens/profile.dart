import 'package:employee_timesheet/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utilis/fire_auth.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool  _isSigningOut = false;
  late User _currentUser;
  @override
  void initState(){
    _currentUser = widget.user;
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:Text('profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('EmployeeId: ${_currentUser.displayName}',
             style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Text('Email: ${_currentUser.email}',
             style: Theme.of(context).textTheme.bodyText1,
            ),
             SizedBox(height: 16.0),
             _currentUser.emailVerified
                ? Text(
                    'Email verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.green),
                  )
                : Text(
                    'Email not verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.red),
                  ),
                  SizedBox(height: 16.0),
                  _isSendingVerification
                  ? CircularProgressIndicator()
                  :Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(onPressed: () async{
                        setState(() {
                            _isSendingVerification = true;
                        });
                        
                      }, 
                      child: Text('Verify Email'),
                      ),
                      SizedBox(width: 10.0),
                      IconButton( icon: Icon(Icons.refresh),
                      onPressed: () async {
                        User? user = await FireAuth.refreshUser(_currentUser);
                        if(user != null){
                          setState(() {
                            _currentUser = user;
                          });
                        }
                      },)


                    ],
                  ),
                   SizedBox(height: 16.0),
            _isSigningOut
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>const LoginScreen(),
                        ),
                      );
                    },
                    child: Text('Sign out'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),


          ],
        ),
      ),
    );
  }
}