import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/auth_controller.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/models/bmi_model.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/views/user/settings/bluetooth_search_page.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/buttons/toggle_gender_button.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class EditSettingsView extends StatefulWidget {
  EditSettingsView({this.user});

  final AppUser? user;

  @override
  _EditSettingsViewState createState() => _EditSettingsViewState();
}

class _EditSettingsViewState extends State<EditSettingsView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  final AuthController _auth = AuthController();

  String? _gender;
  int? height;

  @override
  void initState() {
    _gender = widget.user!.gender;
    _userNameController.text = widget.user!.userName!;
    _ageController.text = widget.user!.age.toString();
    _weightController.text = widget.user!.weight.toString();
    _heightController.text = widget.user!.height.toString();
    height = widget.user!.height;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _userNameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
  }

  void toggleGender(String selectedGender) {
    _gender = selectedGender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: H1Text(text: "Instellingen wijzigen"),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [],
        leading: IconButton(
          icon: Icon(HealthpointIcons.arrowLeftIcon),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
              vertical: MediaQuery.of(context).size.width * 0.08,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                H2Text(text: "Geslacht"),
                SizedBox(height: 20),
                ToggleGenderButton(onTap: toggleGender),
                SizedBox(height: 30),
                H2Text(text: "Gebruikersnaam"),
                CustomTextFormField(
                  keyboardType: TextInputType.name,
                  textcontroller: _userNameController,
                  errorMessage: "Vul een naam in",
                  validator: 1,
                  secureText: false,
                ),
                SizedBox(height: 20),
                H2Text(text: "Leeftijd"),
                CustomTextFormField(
                  keyboardType: TextInputType.number,
                  textcontroller: _ageController,
                  errorMessage: "Vul een leeftijd in",
                  validator: 6,
                  secureText: false,
                ),
                SizedBox(height: 20),
                H2Text(text: "Gewicht"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        keyboardType: TextInputType.number,
                        textcontroller: _weightController,
                        errorMessage: "Vul een gewicht in",
                        validator: 6,
                        secureText: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: IconButton(
                          icon: Icon(
                            Icons.bluetooth,
                            color: Theme.of(context).primaryColor,
                            size: MediaQuery.of(context).size.width * 0.08,
                          ),
                          onPressed: () => {
                                FocusScope.of(context).unfocus(),
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                      builder: (context) => BluetoothSearchPage(
                                          user: widget.user!),
                                    ))
                                    .then((value) => value != null
                                        ? _weightController.text =
                                            value.toString()
                                        : null)
                              }),
                    )
                  ],
                ),
                SizedBox(height: 20),
                H2Text(
                  text: 'Lengte in cm',
                ),
                CustomTextFormField(
                  keyboardType: TextInputType.number,
                  textcontroller: _heightController,
                  errorMessage: "Vul een lengte in",
                  validator: 6,
                  secureText: false,
                ),
                SizedBox(height: 50),
                ConfirmOrangeButton(
                    text: "Opslaan", onTap: () => saveSettings())
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveSettings() {
    if (_formKey.currentState!.validate()) {
      BMI bmi = BMI(
        age: int.parse(_ageController.text),
        height: int.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        gender: _gender,
      );
      _auth.updateUserData(widget.user!.id, _userNameController.text, bmi).then(
        (value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: ColorTheme.lightOrange,
              content: Text(
                // ignore: lines_longer_than_80_chars
                "Uw instellingen worden de volgende keer als u inlogd gewijzigd",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15),
              ),
            ),
          );

          Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.pop(context);
          });
        },
      );
    }
  }
}
