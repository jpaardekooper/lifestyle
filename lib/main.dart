import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/home.dart';
import 'package:lifestylescreening/views/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'helper/constants.dart';

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
  bool isUserLoggedIn;

  @override
  void initState() {
    isUserLoggedIn = false;
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await Constants.getUerLoggedInSharedPreference().then((value) {
      if (value != true) {
        isUserLoggedIn = false;
      } else {
        isUserLoggedIn = value;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifestyle Screening',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isUserLoggedIn ? Home() : HomeScreen(),
    );
  }
}
