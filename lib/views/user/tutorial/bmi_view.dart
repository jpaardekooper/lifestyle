import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/bmi_model.dart';
import 'package:lifestylescreening/views/user/tutorial/select_interests_view.dart';
import 'package:lifestylescreening/widgets/appbar/introduction_appbar.dart';
import 'package:lifestylescreening/widgets/bottom/tutorial_buttons.dart';
import 'package:lifestylescreening/widgets/buttons/toggle_gender_button.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:lifestylescreening/widgets/text/h3_grey_text.dart';
import 'package:lifestylescreening/widgets/transitions/route_transition.dart';

class BMIView extends StatefulWidget {
  BMIView({this.username});
  final String username;

  @override
  _BMIViewState createState() => _BMIViewState();
}

class _BMIViewState extends State<BMIView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  bool isSwitched = false;
  String _gender = 'male';

  void goToSelectInterest() {
    if (_formKey.currentState.validate()) {
      BMI bmi = BMI(
        age: int.parse(_ageController.text),
        height: int.parse(_heightController.text),
        weight: int.parse(_weightController.text),
        gender: _gender,
      );
      //removes existing keyboard
      FocusScope.of(context).unfocus();

      Navigator.of(context).push(
        createRoute(SelectInterestsView(
          username: widget.username,
          bmi: bmi,
        )),
      );
    }
  }

  void goBack() {
    //removes existing keyboard
    FocusScope.of(context).unfocus();

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
  }

  void toggleGender(String selectedGender) {
    _gender = selectedGender;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: introductionAppBar(context, 0.4, false),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    H2Text(text: "Wat is uw geslacht?"),
                    SizedBox(
                      height: 20,
                    ),
                    ToggleGenderButton(
                      onTap: toggleGender,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    H2Text(text: "Wat is uw leeftijd?"),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      textcontroller: _ageController,
                      errorMessage: "Geen geldige getal",
                      validator: 6,
                      secureText: false,
                      hintText: "Vul hier uw leeftijd in",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    H2Text(text: "Wat is uw lengte?"),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      textcontroller: _heightController,
                      errorMessage: "Geen geldige getal",
                      validator: 6,
                      secureText: false,
                      suffixText: "cm",
                      hintText: "Vul hier uw lengte in cm",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    H2Text(text: "Wat is uw gewicht?"),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      textcontroller: _weightController,
                      errorMessage: "Geen geldige getal",
                      validator: 6,
                      secureText: false,
                      suffixText: "kg",
                      hintText: "Vul hier uw gewicht in in kilo's",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Hero(
                        tag: 'intro-text',
                        child: Material(
                          color: Colors.transparent,
                          child: H3GreyText(
                              text:
                                  // ignore: lines_longer_than_80_chars
                                  "We gebruiken uw BMI-index om de ervaring van de app te personaliseren."),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TutorialButtons(
                canGoBack: true,
                onPressedBack: goBack,
                onPressedNext: goToSelectInterest,
              )
            ],
          ),
        ),
      ),
    );
  }
}
