import 'package:employee_timesheet/screens/home_page.dart';
import 'package:employee_timesheet/screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/luser_provider.dart';
import '../resource/auth.dart';
import '../utilis/validator.dart';
import '../widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
 final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _employeeidController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  bool _isProcessing = false;

  @override
  void registerUser() async {
    String res = await AuthMethods().registerUser(
        email: _emailController.text,
        password: _passwordController.text,
       employeeid: _employeeidController.text);
    if (res == "Success") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
         
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 150, left: 30, right: 30, bottom: 550),
              child: Column(
                children: <Widget>[
                  // logoWidget(),
                  const SizedBox(
                    height: 10,
                  ),

                  reusableTextField("Enter Username", Icons.person_outlined,
                      false, false, true, false, _usernameController, "name"),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Email Id", Icons.email_outlined,
                      false, true, false, false, _emailController, "email"),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Password", Icons.lock_outline, true,
                      false, false, false, _passwordController, "password"),
                  const SizedBox(
                    height: 20,
                  ),
                  button(
                    context,
                    "Sign Up",
                    () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      registerUser();
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

  
//   final _signupFormKey = GlobalKey<FormState>();

//   // final _EmployeeIdTextController = TextEditingController();
//   // final _emailTextController = TextEditingController();
//   // final _passwordTextController = TextEditingController();

//   // final _focusEmployeeId = FocusNode();
//   // final _focusEmail = FocusNode();
//   // final _focusPassword = FocusNode();

//   // bool _isProcessing = false;
//   Future<FirebaseApp> _initializeFirebase() async {
//     FirebaseApp firebaseApp = await Firebase.initializeApp();
//     return firebaseApp;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(create: (context)=> ProviderState(),
//     builder: (context, child) {
//       var provider = context.watch<ProviderState>();
    
//     return GestureDetector(
//       onTap: () {
//         provider.focusEmployeeId.unfocus();
//         provider.focusEmail.unfocus();
//         provider.focusPassword.unfocus();
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Employee Details'),
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Image.asset('assets/employee image.png'),
//               ),
//               const SizedBox(height: 20.0),
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Text(
//                   'Sign Up',
//                   style: Theme.of(context).textTheme.headline1,
//                 ),
//               ),
//               Form(
//                 key: _signupFormKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     TextFormField(
//                       controller: provider.emailTextController,
//                       focusNode: provider.focusEmail,
//                       validator: (value) => Validator.validateEmail(
//                         email: value,
//                       ),
//                       decoration: InputDecoration(
//                         icon: Icon(Icons.email),
//                         hintText: 'Enter Your Email',
//                         labelText: 'Email',
//                         errorBorder: UnderlineInputBorder(
//                           borderRadius: BorderRadius.circular(6.0),
//                           borderSide: const BorderSide(
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       controller: provider.EmployeeIdTextController,
//                       focusNode: provider.focusEmployeeId,
//                       validator: (value) => Validator.validateEmployeeid(
//                         employeeid: value,
//                       ),
//                       decoration: InputDecoration(
//                         icon: Icon(Icons.person),
//                         hintText: ' Employee Id',
//                         labelText: 'Employee Id',
//                         errorBorder: UnderlineInputBorder(
//                           borderRadius: BorderRadius.circular(6.0),
//                           borderSide: const BorderSide(
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ),
//                     TextFormField(
//                       controller: provider.passwordTextController,
//                       focusNode: provider.focusPassword,
//                       obscureText: true,
//                       validator: (value) => Validator.validatePassword(
//                         Password: value,
//                       ),
//                       decoration: InputDecoration(
//                         icon: Icon(Icons.lock),
//                         hintText: 'Enter Your Password',
//                         labelText: 'Password',
//                         errorBorder: UnderlineInputBorder(
//                           borderRadius: BorderRadius.circular(6.0),
//                           borderSide: const BorderSide(
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 15.0),
//                     provider.isProcessing
//                         ? CircularProgressIndicator()
//                         : TextButton.icon(
//                             onPressed: (() async {
                             
//                               if (_signupFormKey.currentState!.validate()) {
//                                 var user = await provider.signupwithFirebase();
                               
//                                 if (user != null) {
//                                   Navigator.of(context).pushAndRemoveUntil(
//                                     MaterialPageRoute(
//                                         builder: (context) =>
//                                              ProfilePage(user: user,)),
//                                     ModalRoute.withName('/'),
//                                   );
//                                 }
//                               }
//                             }),
//                             icon: const Icon(Icons.create),
//                             label: Container(
//                               alignment: Alignment.center,
//                               width: 150,
//                               height: 25,
//                               decoration: BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.circular(25),
//                               ),
//                               child: const Text(
//                                 'Sign Up',
//                                 style: TextStyle(
//                                   fontSize: 22,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text('Already have an account?'),
//                         TextButton(
//                           onPressed: (() {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const HomeScreen()),
//                             );
//                           }),
//                           child: const Text(
//                             'Sign In',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//     },
//     );
//   }
// }
