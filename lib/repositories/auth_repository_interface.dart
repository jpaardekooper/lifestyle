import 'package:flutter/cupertino.dart';
import 'package:lifestylescreening/models/bmi_model.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/goals_model.dart';
import 'package:lifestylescreening/models/interest_model.dart';

abstract class IAuthRepository {
  Future signInWithEmailAndPassword(String? email, String? password);

  Future signUpWithEmailAndPassword(
      String email,
      String username,
      String password,
      BMI? bmi,
      List<InterestModel>? interestList,
      List<GoalsModel> goalsList);

  Future updateUserData(String? userId, String userName, BMI bmi);

  Future signOut(BuildContext context);

  saveUserDetailsOnLogin(AppUser user, String password, bool? rememberMe);

  Future resetPass(String email);

  Future<void> subscribeToLifestyle(Map data);
}
