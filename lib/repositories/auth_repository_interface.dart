import 'package:lifestylescreening/models/firebase_user.dart';

abstract class IAuthRepository {
  Future signInWithEmailAndPassword(String email, String password);

  Future signUpWithEmailAndPassword(
      String email, String username, String password);

  Future signOut();

  saveUserDetailsOnLogin(AppUser user, String password, bool rememberMe);

  Future resetPass(String email);
}
