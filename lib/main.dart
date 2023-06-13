import 'package:employee_timesheet/screens/home_page.dart';
import 'package:employee_timesheet/screens/login_page.dart';
import 'package:employee_timesheet/screens/signup_page.dart';
import 'package:employee_timesheet/utilis/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class MyApp extends StatelessWidget {
  // late final User user;
  @override
  Widget build(BuildContext context) {
    return 
    StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return const HomeScreen();
        }else if(snapshot.hasData){
          return Center(
            child: Text('${snapshot.error}'),
          );

        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return const LoginScreen();
      });
  }

}
    // MultiProvider(
    //   providers: [
    //     Provider<FireAuth>(
    //       create: (_) => FireAuth(),
    //     ),
    //   ],
    // );

    // child:
//     MaterialApp(
//       title: 'Employee TimeSheet',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.light,
//         primarySwatch: Colors.blue,
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             textStyle: const TextStyle(
//               fontSize: 24.0,
//             ),
//             padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
//           ),
//         ),
//         textTheme: TextTheme(
//           headline1: TextStyle(
//             fontSize: 46.0,
//             color: Colors.blue.shade700,
//             fontWeight: FontWeight.w500,
//           ),
//           bodyText1: const TextStyle(fontSize: 18.0),
//         ),
//       ),

//       home: const HomeScreen(),
//       //  initialRoute: '/home_page',
//       //  routes: {
//       //   MyRoutes.homeScreen:(context) => const HomeScreen(),
//       //   MyRoutes.forgetpassword:(context) => const ForgotPassword(),
//       //   MyRoutes.loginScreen:(context) => const LoginScreen(),
//       //   MyRoutes.signup:(context) => const SignUp(),
//       //   MyRoutes.employeeprofile:(context) =>  EmployeeProfile(user: user,),
//       //   MyRoutes.profile:(context) => ProfilePage(user: user),
//       //  }
//     );
//   }
// }
