import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/user/tutorial/bmi_view.dart';
import 'package:lifestylescreening/widgets/appbar/introduction_appbar.dart';
import 'package:lifestylescreening/widgets/bottom/tutorial_buttons.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';

class AboutYouView extends StatefulWidget {
  AboutYouView({Key key}) : super(key: key);

  @override
  _AboutYouViewState createState() => _AboutYouViewState();
}

class _AboutYouViewState extends State<AboutYouView> {
  TextEditingController _usernameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void validateName() {
    if (_formKey.currentState.validate()) {
      //removes existing keyboard
      FocusScope.of(context).unfocus();

      Navigator.of(context).push(
        createRoute(
          BMIView(
            username: _usernameController.text,
          ),
        ),
      );
    }
  }

  void goBack() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: introductionAppBar(context, 0.2, false),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'intro-text',
                  child: Wrap(
                    children: [
                      H1Text(text: "Welkom bij HealthPoint."),
                      H1Text(text: "Laten we elkaar beter leren kennen."),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                H2Text(text: "Wat is uw naam?"),
                Form(
                  key: _formKey,
                  child: CustomTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textcontroller: _usernameController,
                    errorMessage: "Geen geldige gebruikersnaam",
                    validator: 1,
                    secureText: false,
                  ),
                ),
              ],
            ),
          ),
          TutorialButtons(
            canGoBack: true,
            onPressedBack: goBack,
            onPressedNext: validateName,
          ),
        ],
      ),
    );
  }
}
