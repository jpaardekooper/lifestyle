import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/web/utils/responsive_layout.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';

class SendBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ColorTheme.accentOrange, ColorTheme.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF6078ea).withOpacity(.3),
                  offset: Offset(0.0, 8.0),
                  blurRadius: 8.0)
            ]),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Subscribe",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              ResponsiveLayout.isSmallScreen(context) ? 12 : 24,
                          letterSpacing: 1.0)),
                  SizedBox(
                    width: ResponsiveLayout.isSmallScreen(context)
                        ? 4
                        : ResponsiveLayout.isMediumScreen(context)
                            ? 6
                            : 8,
                  ),
                  ResponsiveLayout.isSmallScreen(context)
                      ? Container()
                      : Icon(
                          Icons.mail,
                          color: Colors.white,
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
