// import 'package:employee_timesheet/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';


 class FireAuth{
  static Future<User?> signUpUsingEmailPassword({
    required String employeeId,
    required String email,
    required String Password,
  }) async {
    FirebaseAuth auth =FirebaseAuth.instance;
    User? user;
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: Password);
        user = userCredential.user;
      await user!.updateProfile(displayName: employeeId);
      await user.reload();
      user = auth.currentUser; 
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
        



    }catch(e){
      print(e);
    }
    return user;
  }
  // Stream<User?>? get User{
  //   return FirebaseAuth.authStateChanges().map((userFromFirebase) );
  // }
  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static sendPasswordResetEmail({required String email}) async{
     FirebaseAuth auth =FirebaseAuth.instance;
    User? user;
    
      await auth.sendPasswordResetEmail(email: email) ;
  }
 }
 















// class FireAuth{
//   final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance ;
//   User? _userFromFirebase(auth.User? user){
//     if
//   }
// }


