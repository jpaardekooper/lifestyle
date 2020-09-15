import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User _userFromFirebaseUser(User user) {

  //   return user != null ? User(uid:  user.uid) : null;
  // }

  // Future signInEmailAndPass(String email, String password) async{
  //   try{
  //     UserCredential authResult =
  //     await _auth.signInWithEmailAndPassword(email: email, password: password);
  //     User firebaseUser = authResult.user;
  //   //  return _userFromFirebaseUser(firebaseUser);
  //   }catch(e){
  //     print(e);
  //   }
  // }

  Future signInWithEmailAndPassword(
      String _emailController, String _passwordController) async {
    try {
      User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController,
        password: _passwordController,
      ))
          .user;
    } catch (e) {
      print(e + "dsa");
    }
  }
}

//   Future signUpWithEmailAndPassword(String email, String password) async {

//     try{
//       UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//       User user = authResult.user;
//       return _userFromFirebaseUser(user);
//     }catch(e){
//       print(e.toString());
//       return null;
//     }

//   }

//   Future signOut() async{

//     try{
//       return await _auth.signOut();
//     }catch(e){
//       print(e.toString());
//       return null;
//     }
//   }

//   Future resetPass(String email) async{
//     try{
//       return await _auth.sendPasswordResetEmail(email: email);
//     }catch(e){
//       print(e.toString());
//       return null;
//     }
//   }
// }
