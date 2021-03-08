import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/tutorial/about_you_view.dart';
import 'package:lifestylescreening/widgets/bottom/tutorial_buttons.dart';
import 'package:lifestylescreening/widgets/cards/disclaimer_card.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/painter/top_small_wave_painter.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';

class DisclaimerView extends StatefulWidget {
  const DisclaimerView({Key? key}) : super(key: key);

  @override
  _DisclaimerViewState createState() => _DisclaimerViewState();
}

class _DisclaimerViewState extends State<DisclaimerView> {
  void onTap() {
    Navigator.of(context).push(
      createRoute(
        AboutYouView(),
      ),
    );
  }

  void goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, size.height),
            painter: TopSmallWavePainter(
              color: ColorTheme.extraLightOrange,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.08),
                      child: DisclaimerCard(),
                    ),
                    TutorialButtons(
                      canGoBack: true,
                      onPressedBack: goBack,
                      onPressedNext: onTap,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
