import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/signin.dart';
import 'package:lifestylescreening/views/signup.dart';
import 'package:lifestylescreening/widgets/buttons/background_dark_button.dart';
import 'package:lifestylescreening/widgets/buttons/background_white_button.dart';

import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';

class StartUp extends StatefulWidget {
  StartUp({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StartUp> {
  Widget build(BuildContext context) {
    return showStartUp(context);
    // return ChangeNotifierProvider(
    //   create: (_) => UserRepository.instance(),
    //   child: Consumer(
    //     builder: (context, UserRepository user, _) {
    //       switch (user.status) {
    //         case Status.uninitialized:
    //         //splash screen for x seconds
    //         case Status.unauthenticated:
    //           return showStartUp(context);
    //         case Status.signin:
    //           return SignIn();
    //         case Status.signup:
    //           return SignUp();
    //         case Status.authenticating:
    //           return LoginVisual();
    //         case Status.authenticated:
    //           return Home();
    //       }
    //     },
    //   ),
    // );
  }
}

Widget showStartUp(BuildContext context) {
  // Scaffold is used to utilize all the material widgets
  return Scaffold(
    backgroundColor: Color.fromRGBO(255, 129, 128, 1),
    body: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Spacer(flex: 2),
          LifestyleLogo(size: 50),
          SizedBox(
            height: 16,
          ),
          Spacer(flex: 1),
          Material(
            color: Color.fromRGBO(72, 72, 72, 1),
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              borderRadius: BorderRadius.circular(40.0),
              child: BackgroundDarkButton(
                text: 'Inloggen',
                size: 25,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignIn(),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Material(
            color: Color.fromRGBO(255, 129, 128, 1),
            borderRadius: BorderRadius.circular(40),
            child: InkWell(
              splashColor: Colors.white,
              borderRadius: BorderRadius.circular(40.0),
              child: BackgroundWhiteButton(text: 'Aanmelden', size: 25),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUp(),
                  ),
                );
              },
            ),
          ),
          Spacer(flex: 4),
        ],
      ),
    ),
  );
}
