import 'package:flutter/material.dart';
import 'package:lifestylescreening/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lifestylescreening/views/disclaimer_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lifestylescreening/views/startup.dart';
import 'package:lifestylescreening/widgets/login/login_visual.dart';

import 'helper/functions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) => initializeDateFormatting().then(
        (value) => runApp(
          MyApp(),
        ),
      ));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthService authService = AuthService();
  bool _disclaimerAccepted = false;
  bool _isLoggedin = false;
  String _email, _password, _role;
  dynamic result;

  @override
  void initState() {
    checkDisclaimerStatus();
    checkUserLoggedInStatus();

    super.initState();
  }

  Future checkDisclaimerStatus() async {
    await HelperFunctions.getDisclaimerSharedPreference().then((value) {
      setState(() {
        _disclaimerAccepted = value;
      });
    });
  }

  Future checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if (value ?? false) {
        getUserInfo();
      }
      setState(() {
        _isLoggedin = value;
      });
    });
  }

  getUserInfo() async {
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      _email = value;
    });

    await HelperFunctions.getUserPasswordSharedPreference().then((value) {
      _password = value;
    });

    await HelperFunctions.getUserRoleSharedPreference().then((value) {
      _role = value;
    });

    result = await authService.signInWithEmailAndPassword(_email, _password);
    setState(() {});
  }

  signIn() {
    if (result != null) {
      return LoginVisual(_role);
    } else {
      return StartUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifestyle Screening',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF3b4254),
        accentColor: const Color(0xFFddb461),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      home:
          //if the vallue is null (not found) change value to false
          (_disclaimerAccepted ?? false)
              //if the vallue is null (not found) change value to false
              ? (_isLoggedin ?? false)
                  ? signIn()
                  : StartUp()
              : DisclaimerScreen(),
    );
  }
}
