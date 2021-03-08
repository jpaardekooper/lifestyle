import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';

import 'package:lifestylescreening/widgets/bottom/tutorial_buttons.dart';
import 'package:lifestylescreening/widgets/cards/disclaimer_card.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/painter/top_small_wave_painter.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';
import 'package:lifestylescreening/widgets/web/start_survey.dart';

class WebDisclaimer extends StatefulWidget {
  const WebDisclaimer({Key? key}) : super(key: key);

  @override
  _WebDisclaimerViewState createState() => _WebDisclaimerViewState();
}

class _WebDisclaimerViewState extends State<WebDisclaimer> {
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  onTap() async {
    String? id = await _questionnaireController.createDTDid();

    await Navigator.of(context).push(
      createRoute(
        StartSurvey(docId: id),
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
