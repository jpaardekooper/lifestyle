import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/tutorial/disclaimer_view.dart';
import 'package:lifestylescreening/views/user/tutorial/signin.dart';
import 'package:lifestylescreening/views/web/utils/responsive_layout.dart';
import 'package:lifestylescreening/views/web/widgets/navbar.dart';
import 'package:lifestylescreening/views/web/widgets/search.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/painter/landing_page_painter.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';
import 'package:lifestylescreening/widgets/web/web_disclaimer.dart';

class LandingPageApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  final snackBar = SnackBar(content: Text('Bedankt voor het abonneren!'));

  void subscribe(BuildContext context) {
    _drawerKey.currentState.showSnackBar(snackBar);
    //when dart sdk has been updated
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey, // a
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: LandingPagePainter(
                color: ColorTheme.extraLightOrange,
              ),
            ),
            Column(
              children: <Widget>[
                NavBar(
                  function: openDrawer,
                ),
                Body(function: subscribe),
              ],
            ),
          ],
        ),
      ),

      //   endDrawerEnableOpenDragGesture: false, // THIS WAY IT WILL NOT OPEN
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Lifestyle ", style: TextStyle(fontSize: 24)),
                      Text("Screening", style: TextStyle(fontSize: 24))
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: ColorTheme.extraLightGreen,
              ),
            ),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    ColorTheme.accentOrange,
                    ColorTheme.accentOrange,
                  ], begin: Alignment.bottomRight, end: Alignment.topLeft),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF6078ea).withOpacity(.3),
                        offset: Offset(0, 8),
                        blurRadius: 8)
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    child: Text("Doe de test!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  createRoute(
                    WebDisclaimer(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                "Inloggen",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                  createRoute(
                    SignIn(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                "Aanmelden",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                  createRoute(
                    DisclaimerView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  Body({@required this.function});
  final Function(BuildContext) function;
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      largeScreen: LargeChild(function: function),
      smallScreen: SmallChild(function: function),
    );
  }
}

class LargeChild extends StatelessWidget {
  LargeChild({@required this.function});
  final Function(BuildContext) function;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: .6,
            child: Image.asset(
              'assets/images/poppetje1.png',
              scale: 1,
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: .6,
            child: Padding(
              padding: EdgeInsets.only(left: 80, right: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: "Welkom bij ",
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                              text: "Lifestyle Screening",
                              style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: ColorTheme.accentOrange))
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 20),
                    child: Text(
                      "Voor een gezondere levenstijl",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Search(function: function)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SmallChild extends StatelessWidget {
  SmallChild({@required this.function});
  final Function(BuildContext) function;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "Welkom bij ",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                      text: "Lifestyle Screening",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: ColorTheme.accentOrange))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 20),
              child: Text(
                "Voor een gezondere levenstijl",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Image.asset(
                'assets/images/poppetje1.png',
                scale: 2,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Search(function: function),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
