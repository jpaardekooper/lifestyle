import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
  signup,
  signin
}

class UserRepository with ChangeNotifier {
  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  FirebaseAuth _auth;
  User _user;
  Status _status = Status.uninitialized;

  Status get status => _status;
  User get user => _user;

  Future signInPage() async {
    _status = Status.signin;
    notifyListeners();
  }

  Future signUpPage() async {
    _status = Status.signup;
    notifyListeners();
  }

  Future resetStatus() async {
    _status = Status.unauthenticated;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      _status = Status.authenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    await _auth.signOut().then((value) {
      _status = Status.unauthenticated;
      notifyListeners();
    });

    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.unauthenticated;
    }
    notifyListeners();
  }
}
