import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/models/bmi_model.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifestylescreening/models/goals_model.dart';
import 'package:lifestylescreening/models/interest_model.dart';
import 'package:lifestylescreening/repositories/auth_repository_interface.dart';
import 'package:lifestylescreening/views/user/tutorial/startup.dart';

class AuthRepository extends IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<AppUser> userFromFirebaseUser(
    User user,
  ) async {
    AppUser _appUser;

    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("email", isEqualTo: user.email)
          .get();

      snapshot.docs.map((DocumentSnapshot doc) {
        _appUser = AppUser.fromSnapshot(doc);
      }).toList();

      return _appUser;
    } else {
      return null;
    }
  }

  @override
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = authResult.user;

      return userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //   print('Wrong password provided for that user.');
      }

      //   print('Failed with error code: ${e.code}');
      return null;
      // ignore: avoid_catches_without_on_clauses
    }
  }

  @override
  Future signUpWithEmailAndPassword(
    String email,
    String username,
    String password,
    BMI bmi,
    List<InterestModel> interestList,
    List<GoalsModel> goalsList,
  ) async {
    try {
      var _appUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      List<String> recept = [];

      Map<String, dynamic> userInfo = {
        "userName": username,
        "email": email,
        "role": "user",
        "uid": _appUser.user.uid,
        "age": bmi.age,
        "height": bmi.height,
        "weight": bmi.weight,
        "gender": bmi.gender,
        "favorite_recipes": recept
      };

      await FirebaseFirestore.instance
          .collection("users")
          .add(userInfo)
          .catchError((e) {
        //   print(e);
      }).then((value) async {
        for (int i = 0; i < interestList.length; i++) {
          Map<String, dynamic> interestsInfo = {
            "interest": interestList[i].interest,
          };

          await FirebaseFirestore.instance
              .collection("users")
              .doc(value.id)
              .collection("interests")
              .add(interestsInfo)
              .catchError((e) {});
        }

        for (int i = 0; i < goalsList.length; i++) {
          Map<String, dynamic> goalsInfo = {
            "goal": goalsList[i].goals,
          };

          await FirebaseFirestore.instance
              .collection("users")
              .doc(value.id)
              .collection("goals")
              .add(goalsInfo)
              .catchError((e) {});
        }
        await HelperFunctions.saveUserNameSharedPreference(username);
        await HelperFunctions.saveUserEmailSharedPreference(email);
        await HelperFunctions.saveUserPasswordSharedPreference(password);
        await HelperFunctions.saveUserRoleSharedPreference("user");
      });

      User firebaseUser = _appUser.user;

      return userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // errorMessage = e.code;
      } else if (e.code == 'wrong-password') {
        //     errorMessage = e.code;
      }

      return null;
    }
  }

  @override
  Future updateUserData(String userId, String userName, BMI bmi) async {
    await FirebaseFirestore.instance.collection("users").doc(userId).update({
      'userName': userName,
      "age": bmi.age,
      "height": bmi.height,
      "weight": bmi.weight,
      "gender": bmi.gender,
    });
  }

  @override
  Future signOut(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await HelperFunctions.saveUserLoggedInSharedPreference(false);
    await HelperFunctions.removeUserNameSharedPreference();
    await HelperFunctions.removeUserEmailSharedPreference();
    await HelperFunctions.removeUserPasswordSharedPreference();

    await _auth.signOut();

    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => StartUp()));
  }

  @override
  saveUserDetailsOnLogin(AppUser user, String password, bool rememberMe) async {
    if (rememberMe) {
      await HelperFunctions.saveUserLoggedInSharedPreference(rememberMe);

      await HelperFunctions.saveUserNameSharedPreference(user.userName);
      await HelperFunctions.saveUserEmailSharedPreference(user.email);
      await HelperFunctions.saveUserPasswordSharedPreference(password);
    }
  }

  @override
  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      //  print(e.toString());
      return null;
    }
  }

  @override
  Future<void> subscribeToLifestyle(Map data) async {
    await FirebaseFirestore.instance.collection("subscribers").doc().set(data);
  }
}
