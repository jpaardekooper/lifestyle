import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/web/utils/responsive_layout.dart';
import 'package:lifestylescreening/views/web/widgets/navbar.dart';
import 'package:lifestylescreening/views/web/widgets/search.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/painter/landing_page_painter.dart';

class LandingPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFFF8FBFF),
        Color(0xFFFCFDFD),
      ])),
      child: Scaffold(
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
                  NavBar(),
                  Body(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      largeScreen: LargeChild(),
      smallScreen: SmallChild(),
    );
  }
}

class LargeChild extends StatelessWidget {
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
                  Text(
                    "",
                  ),
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
                  Search()
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
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Hallo!",
              style: TextStyle(
                fontSize: 40,
                color: Color(0xFF8591B0),
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Welkom bij',
                style: TextStyle(fontSize: 40, color: Color(0xFF8591B0)),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Lifestyle Screening',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.black87)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 20),
              child: Text("Voor een gezondere levensstijl!"),
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
            Search(),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
