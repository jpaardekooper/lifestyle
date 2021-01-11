import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/auth_controller.dart';
import 'package:lifestylescreening/models/bmi_model.dart';
import 'package:lifestylescreening/models/goals_model.dart';
import 'package:lifestylescreening/models/interest_model.dart';
import 'package:lifestylescreening/widgets/appbar/introduction_appbar.dart';
import 'package:lifestylescreening/widgets/bottom/tutorial_buttons.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/login/login_visual.dart';
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';

class SignUp extends StatefulWidget {
  SignUp(
      {Key key,
      @required this.username,
      @required this.bmi,
      @required this.selectedInterest,
      @required this.goalsList})
      : super(key: key);
  final String username;
  final BMI bmi;
  final List<InterestModel> selectedInterest;
  final List<GoalsModel> goalsList;

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordChecker = TextEditingController();
  final _key = GlobalKey<ScaffoldState>();
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username ?? "";
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordChecker.dispose();
    super.dispose();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void registerAccount() {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      checkAccountDetails();
    } else {
      resetSignInPage();
    }
  }

  checkAccountDetails() async {
    var _appUser = await _authController.signUpWithEmailAndPassword(
      _emailController.text,
      _usernameController.text,
      _passwordController.text,
      widget.bmi,
      widget.selectedInterest,
      widget.goalsList,
    );
    //   .then((value) {
    if (_appUser != null) {
      /// mapping user data
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InheritedDataProvider(
            data: _appUser,
            child: LoginVisual(),
          ),
        ),
      );
    } else {
      resetSignInPage();
    }
  }

  void resetSignInPage() {
    setState(() {
      isLoading = false;

      _key.currentState.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Theme.of(context).accentColor,
          content: Text(
            "Er is iets mis gegaan probeer het nog eens",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     duration: const Duration(seconds: 1),
      //     backgroundColor: Theme.of(context).accentColor,
      //     content: Text(
      //       "Uw email en wachtwoord komen niet overeen",
      //       style: TextStyle(color: Colors.white, fontSize: 18),
      //     ),
      //   ),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      appBar: introductionAppBar(context, 1, false),
      key: _key,
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08, vertical: size.height * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: LifestyleLogo(
                      size: 100,
                      description: "Meld je aan voor een nieuw account",
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("Vul hier uw gebruikersnaam in"),
                  ),
                  // username
                  CustomTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textcontroller: _usernameController,
                    errorMessage: "Geen geldige gebruikersnaam",
                    validator: 1,
                    secureText: false,
                    hintText: 'Hiermee kunnen wij u aanspreken',
                  ),
                  //email
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 16),
                    child: Text("Vul hier uw e-mail adres in"),
                  ),
                  CustomTextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textcontroller: _emailController,
                    errorMessage: "Gebruik een geldige e-mail adres",
                    validator: 2,
                    secureText: false,
                    hintText: 'Vul hier uw e-mail adres in',
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 16),
                    child: Text("Vul hier uw wachtwoord in"),
                  ),
                  //Password
                  CustomTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textcontroller: _passwordController,
                    errorMessage: "Gebruik minimaal 6 karakters",
                    validator: 1,
                    secureText: true,
                    hintText: 'Minimaal 6 karakters',
                  ),

                  Padding(
                      padding: const EdgeInsets.only(left: 8, top: 16),
                      child: Text("Herhaal uw wachtwoord")),
                  //Password Checker
                  CustomTextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textcontroller: _passwordChecker,
                    errorMessage: "wachtwoord komt niet overeen",
                    validator: 3,
                    secureText: true,
                    passwordChecker: _passwordController.text,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 30),
                  isLoading
                      ? Center(
                          child: LinearProgressIndicator(),
                        )
                      : TutorialButtons(
                          canGoBack: true,
                          onPressedBack: goBack,
                          onPressedNext: registerAccount,
                          spacing: true,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
