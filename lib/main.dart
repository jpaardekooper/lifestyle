import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lifestylescreening/views/user/tutorial/startup.dart';
import 'package:lifestylescreening/views/web/landing_page_view.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/login/login_visual.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'helper/functions.dart';

void main() {
  initializeWidgets().then((value) => runApp(MyApp()));
}

Future<void> initializeWidgets() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthController _authController = AuthController();

  bool _isLoggedin = false;
  String _email, _password;
  var result;

  @override
  void initState() {
    super.initState();
    checkUserLoggedInStatus();
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

    result =
        await _authController.signInWithEmailAndPassword(_email, _password);
    setState(() {});
  }

  signIn() {
    if (result != null) {
      return InheritedDataProvider(child: LoginVisual(), data: result);
    } else {
      return StartUp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifestyle Screening',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primaryColor: const Color(0xFF456A67),
        accentColor: const Color(0xFFFA9215),
        fontFamily: 'Sofia',
      ),
      //   initialRoute: '/landing-page',
      routes: {'/landing-page': (context) => LandingPageView()},
      home: kIsWeb
          ? LandingPageView()
          : (_isLoggedin ?? false)
              //if the vallue is null (not found) change value to false

              ? signIn()
              : StartUp(),
    );
  }
}
