import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/signin.dart';
import 'package:lifestylescreening/views/signup.dart';
import 'package:lifestylescreening/widgets/buttons/button_background.dart';
import 'package:lifestylescreening/widgets/layout/expanded_listview.dart';

import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';

class StartUp extends StatefulWidget {
  StartUp({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StartUp> {
  void _goToSignIn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SignIn(),
      ),
    );
  }

  void _goToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SignUp(),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 129, 128, 1),
      body: Container(
        margin: EdgeInsets.only(left: 80, right: 80),
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: ExpandedListView(
                start: false,
                widgets: [LifestyleLogo(size: 60)],
              ),
            ),
            ExpandedListView(
              start: true,
              widgets: [
                ButtonBackground(
                  text: 'Inloggen',
                  size: 25,
                  onTap: _goToSignIn,
                  colorbackground: const Color.fromRGBO(72, 72, 72, 1),
                  dark: true,
                ),
                SizedBox(
                  height: 30,
                ),
                ButtonBackground(
                  text: 'Aanmelden',
                  size: 25,
                  onTap: _goToSignUp,
                  colorbackground: const Color.fromRGBO(255, 129, 128, 1),
                  dark: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
