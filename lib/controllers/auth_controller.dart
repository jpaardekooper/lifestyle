import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/bmi_model.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/goals_model.dart';
import 'package:lifestylescreening/models/interest_model.dart';
import 'package:lifestylescreening/repositories/auth_repository.dart';
import 'package:lifestylescreening/repositories/auth_repository_interface.dart';

class AuthController {
  final IAuthRepository _authRepository = AuthRepository();

  Future signInWithEmailAndPassword(String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future signUpWithEmailAndPassword(
    String email,
    String username,
    String password,
    BMI bmi,
    List<InterestModel> interestList,
    List<GoalsModel> goalsList,
  ) {
    return _authRepository.signUpWithEmailAndPassword(
      email,
      username,
      password,
      bmi,
      interestList,
      goalsList,
    );
  }

  Future updateUserData(String userId, String userName, BMI bmi) {
    return _authRepository.updateUserData(userId, userName, bmi);
  }

  Future signOut(BuildContext context) {
    return _authRepository.signOut(context);
  }

  saveUserDetailsOnLogin(AppUser user, String password, bool rememberMe) {
    return _authRepository.saveUserDetailsOnLogin(user, password, rememberMe);
  }

  Future resetPass(String email) {
    return _authRepository.resetPass(email);
  }
}
