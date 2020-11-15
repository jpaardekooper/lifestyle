import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/repositories/auth_repository.dart';
import 'package:lifestylescreening/repositories/auth_repository_interface.dart';

class AuthController {
  final IAuthRepository _authRepository = AuthRepository();

  Future signInWithEmailAndPassword(String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future signUpWithEmailAndPassword(
      String email, String username, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future signOut() {
    return _authRepository.signOut();
  }

  saveUserDetailsOnLogin(AppUser user, String password, bool rememberMe) {
    return _authRepository.saveUserDetailsOnLogin(user, password, rememberMe);
  }

  Future resetPass(String email) {
    return _authRepository.resetPass(email);
  }
}
