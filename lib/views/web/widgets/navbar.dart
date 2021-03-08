import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/tutorial/disclaimer_view.dart';
import 'package:lifestylescreening/views/user/tutorial/signin.dart';
import 'package:lifestylescreening/views/web/utils/responsive_layout.dart';
import 'package:lifestylescreening/views/web/widgets/hover_text.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';
import 'package:lifestylescreening/widgets/web/web_disclaimer.dart';

class NavBar extends StatelessWidget {
  NavBar({required this.function});
  final VoidCallback function;

  final navLinks = ["Aanmelden", "Inloggen"];

  List<Widget> navItem(BuildContext context) {
    return navLinks.map((text) {
      return Padding(
        padding: EdgeInsets.only(left: 40),
        child: HoverText(
            hoverChild: GestureDetector(
              onTap: () {
                if (text == navLinks.first) {
                  Navigator.of(context).push(
                    createRoute(
                      DisclaimerView(),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    createRoute(
                      SignIn(),
                    ),
                  );
                }
              },
              child: Text(
                text,
                style: TextStyle(
                    color: ColorTheme.accentOrange,
                    fontSize: 22,
                    decoration: TextDecoration.underline),
              ),
            ),
            onHover: (event) {},
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
              ),
            )),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    scale: 0.6,
                  ),
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lifestyle ", style: TextStyle(fontSize: 24)),
                  Text("Screening", style: TextStyle(fontSize: 24))
                ],
              )
            ],
          ),
          if (!ResponsiveLayout.isSmallScreen(context))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[...navItem(context)]..add(
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        createRoute(
                          WebDisclaimer(),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 40),
                      width: 160,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              ColorTheme.accentOrange,
                              ColorTheme.accentOrange,
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft),
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
                                letterSpacing: 1,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
            )
          else
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => function(),
            )
        ],
      ),
    );
  }
}
