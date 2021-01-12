import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/auth_controller.dart';
import 'package:lifestylescreening/views/user/settings/bmi_result_page.dart';
import 'package:lifestylescreening/views/user/settings/calculator_bmi.dart';
import 'package:lifestylescreening/views/user/settings/edit_settings_view.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_grey_button.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/painter/bottom_small_wave_painer.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/h3_orange_text.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';
import 'package:lifestylescreening/widgets/text/intro_light_grey_text.dart';

class PageSettings extends StatelessWidget {
  final AuthController _authController = AuthController();

  Widget settingsUserInfoField(String text, String value, String format) {
    return Container(
      padding: EdgeInsets.only(bottom: 15, top: 30.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 4, color: Colors.black),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IntroGreyText(
            text: text,
          ),
          IntroGreyText(text: value.toString() + format),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    final size = MediaQuery.of(context).size;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: H1Text(
          text: "Instellingen",
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          TextButton(
              child: H3OrangeText(text: "Wijzigen"),
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          EditSettingsView(user: _userData.data),
                    ),
                  ))
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomPaint(
                  size: Size(size.width, size.height),
                  painter: BottomSmallWavePainter(
                    color: ColorTheme.extraLightOrange,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(
                size.width * 0.08,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  H1Text(text: "Persoonlijke instellingen"),
                  SizedBox(
                    height: 20,
                  ),
                  IntroLightGreyText(
                    text: "Verander hier uw gegevens",
                  ),

                  /// ORANGE BLOCK
                  Container(
                    margin: EdgeInsets.only(top: 50, bottom: 50),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFDFB9),
                        borderRadius: BorderRadius.circular(30.0)),
                    height: 100,
                    child: Row(
                      children: [
                        H2Text(text: _userData.data.userName),
                        Spacer(),
                        H2Text(text: _userData.data.age.toString() + " jaar"),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 40),
                    child: Center(
                      child: ConfirmGreyButton(
                        text: "Bereken BMI waarde",
                        onTap: () {
                          CalculatorBMI calc = CalculatorBMI(
                              height: _userData.data.height,
                              weight: _userData.data.weight);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ResultsPage(
                                bmiResult: calc.getBMI(),
                                resultText: calc.getResult(),
                                interpretation: calc.getInterpretation(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  settingsUserInfoField(
                      "Gewicht", _userData.data.weight.toString(), "KG"),
                  settingsUserInfoField(
                      "Lengte", _userData.data.height.toString(), "CM"),
                  settingsUserInfoField(
                      "Geslacht", "", _userData.data.gender.toString()),

                  SizedBox(
                    height: 40,
                  ),

                  Center(
                    child: ConfirmOrangeButton(
                      text: "Uitloggen",
                      onTap: () async {
                        await _authController.signOut(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
