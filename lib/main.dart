import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lifestylescreening/views/disclaimer_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lifestylescreening/views/startup.dart';

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
  bool _disclaimerAccepted = false;
  bool _isLoggedin = false;

  @override
  void initState() {
    checkUserLoggedInStatus();
    checkDisclaimerStatus();
    super.initState();
  }

  Future checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        _isLoggedin = value;
      });
    });
  }

  Future checkDisclaimerStatus() async {
    await HelperFunctions.getDisclaimerSharedPreference().then((value) {
      setState(() {
        _disclaimerAccepted = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifestyle Screening',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],
          iconTheme: IconThemeData(color: Colors.black)),
      home: (_disclaimerAccepted ?? false)
          ? (_isLoggedin ?? false)
              ? Home()
              : StartUp()
          : DisclaimerScreen(),
      // home: DisclaimerScreen(),
    );
  }
}
