import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/home.dart';
import 'package:lifestylescreening/views/startup.dart';
import 'package:firebase_core/firebase_core.dart';

import 'helper/functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedin = false;

  @override
  void initState() {
    checkUserLoggedInStatus();
    super.initState();
  }

  Future checkUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        _isLoggedin = value;
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
      home: (_isLoggedin ?? false) ? Home() : StartUp(),
    );
  }
}
