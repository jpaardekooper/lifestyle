import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/admin/dashboard.dart';
import 'package:lifestylescreening/views/user/home_view.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/painter/top_large_wave_painter.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/h3_grey_text.dart';
import 'package:lifestylescreening/widgets/transitions/image_transition.dart';

class LoginVisual extends StatelessWidget {
  LoginVisual({Key key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void goToDashBoard(BuildContext context, var data) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => InheritedDataProvider(
          data: data,
          child: Dashboard(),
        ),
      ),
    );
  }

  void goToWelcomePage(BuildContext context, var data) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => InheritedDataProvider(
          data: data,
          child: Home(),
        ),
      ),
      ModalRoute.withName('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = InheritedDataProvider.of(context).data;
    final size = MediaQuery.of(context).size;

    Future.delayed(const Duration(seconds: 4), () {
      //if role equals to admin go to dashboard
      if (data.role == "admin") {
        goToDashBoard(context, data);
      } else {
        goToWelcomePage(context, data);
      }
    });
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              CustomPaint(
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height),
                painter: TopLargeWavePainter(
                  color: ColorTheme.extraLightOrange,
                ),
              ),
              Positioned.fill(
                bottom: size.height / 6,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          H2Text(text: "Welkom bij HealthPoint"),
                          SizedBox(height: 10),
                          H1Text(text: data.userName),
                        ],
                      ),
                      //loops through 3 images
                      Hero(
                        tag: 'welcome-logo',
                        child: ImageTransition(),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                bottom: size.height / 6,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: size.width / 2,
                          minWidth: size.width / 2,
                        ),
                        child: H3GreyText(
                          text: "Uw gegevens worden ingeladen. . . ",
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                          constraints: BoxConstraints(
                            maxWidth: size.width / 2,
                            minWidth: size.width / 2,
                          ),
                          child: LinearProgressIndicator()),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
