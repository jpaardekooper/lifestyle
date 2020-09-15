import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'package:lifestylescreening/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // UserModel _userFromFirebaseUser(User user) {
  //   return user != null ? UserModel(uid: user.uid) : null;
  // }

  // Example code of how to sign in with email and password.
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      print("scuccesvol");
      return user;
    } catch (e) {
      print("niet scuccesvol");
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (signUpError) {
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          return "email al in gebruik";
        }
      }
    }
  }
}
