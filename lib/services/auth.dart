import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/models/firebase_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser _userFromFirebaseUser(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    String errorMessage;
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //   print('Wrong password provided for that user.');
      }

      //   print('Failed with error code: ${e.code}');
      errorMessage = e.code;
      return null;
      //   print(e.message);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    String errorMessage;
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;
      return _userFromFirebaseUser(firebaseUser);
      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      //  print(e.toString());
      return null;
    }
  }

  saveUserDetailsOnLogin(String email, String password, bool rememberMe) async {
    String role;
    String username;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: email)
          .get()
          .then(
        (querySnapshot) {
          querySnapshot.docs.forEach(
            (result) {
              //
              //   userRole = result.data()["role"];
              //  await appuser.role = result.data()["userName"];
              //    await print(result.data()["role"]);
              // appUser = result.data()["role"];
              // print("een");
              // await  print(result);
              username = result.data()["userName"];
              role = result.data()["role"];
              // print(appuser.username);
              // appuser.role = result.data()["role"];
              // print(appuser.role);
            },
          );
        },
      );

      if (rememberMe) {
        await HelperFunctions.saveUserLoggedInSharedPreference(true);
      }
      await HelperFunctions.saveUserNameSharedPreference(username);
      await HelperFunctions.saveUserEmailSharedPreference(email);
      await HelperFunctions.saveUserPasswordSharedPreference(password);

      return role;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
//
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      //  print(e.toString());
      return null;
    }
  }
}
