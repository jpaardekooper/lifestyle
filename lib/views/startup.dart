import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/widgets/dialog/disclaimer_dialog.dart';
import 'package:lifestylescreening/views/signin.dart';
import 'package:lifestylescreening/views/signup.dart';
import 'package:lifestylescreening/widgets/buttons/button_background.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';

class StartUp extends StatefulWidget {
  StartUp({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StartUp> {
  bool _disclaimerAccepted;

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

  Future checkDisclaimerStatus() async {
    await HelperFunctions.getDisclaimerSharedPreference().then((value) {
      setState(() {
        _disclaimerAccepted = value;
      });
    });
  }

  void onTap() {
    setState(() {
      _disclaimerAccepted = true;
    });
  }

  Widget build(BuildContext context) {
    checkDisclaimerStatus();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 129, 128, 1),
      body: (_disclaimerAccepted ?? false)
          ? Center(
              child: Container(
                margin: EdgeInsets.only(left: 80, right: 80),
                width: kIsWeb
                    ? MediaQuery.of(context).size.width / 3
                    : MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                child: ListView(
                  shrinkWrap: false,
                  children: [
                    LifestyleLogo(size: 60),
                    kIsWeb
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 12)
                        : Container(),
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
              ),
            )
          : DisclaimerScreen(onTap: onTap),
    );
  }
}
