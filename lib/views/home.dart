import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/constants.dart';
import 'package:lifestylescreening/widgets/widgets.dart';
import 'package:lifestylescreening/services/auth.dart';

import 'homescreen.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService authService;
  bool isUserLoggedIn;

  @override
  void initState() {
    authService = AuthService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: Container(
        child: Column(
          children: [],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.do_not_disturb_off),
          onPressed: () async {
            await authService.signOut().then(
                (value) => Constants.saveUserLoggedInSharedPreference(false));

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }),
    );
  }
}
