import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/tutorial/disclaimer_view.dart';
import 'package:lifestylescreening/views/user/tutorial/signin.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/painter/top_large_wave_painter.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';

class StartUp extends StatefulWidget {
  StartUp({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<StartUp> {
  void _goToSignIn() {
    Navigator.of(context).push(
      createRoute(
        SignIn(),
      ),
    );
  }

  void tutorial() {
    Navigator.of(context).push(
      createRoute(
        DisclaimerView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: 'background',
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: TopLargeWavePainter(
                color: ColorTheme.extraLightOrange,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'intro-text',
                      child: SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            H1Text(
                              text: "Welkom bij",
                            ),
                            H1Text(
                              text: "HealthPoint",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Hero(
                      tag: 'welcome-logo',
                      child: Image.asset(
                        'assets/images/poppetje1.png',
                        scale: 2,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      ConfirmOrangeButton(
                        text: "Inloggen",
                        onTap: _goToSignIn,
                        color: Theme.of(context).primaryColor,
                        bottomColor: ColorTheme.darkGreen,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ConfirmOrangeButton(text: "Registreren", onTap: tutorial)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
