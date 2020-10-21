import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/services/auth.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/widgets/buttons/button_background.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/login/login_visual.dart';
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';
import 'package:lifestylescreening/widgets/text/white_text.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static const Color black = Color.fromRGBO(72, 72, 72, 1);
  static const Color red = Color.fromRGBO(255, 129, 128, 1);

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordChecker = TextEditingController();
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordChecker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(255, 129, 128, 1),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 28),
              LifestyleLogo(
                size: 18,
                description: "Meld je aan voor een nieuw account",
              ),

              SizedBox(height: MediaQuery.of(context).size.height / 14),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: WhiteText(
                  text: "Vul hier uw gebruikersnaam in",
                  size: 14,
                ),
              ),
              // username
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: _usernameController,
                errorMessage: "Geen geldige gebruikersnaam",
                validator: 1,
                secureText: false,
              ),
              //email
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 16),
                child: WhiteText(
                  text: "Vul hier uw e-mail adres in",
                  size: 14,
                ),
              ),
              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                textcontroller: _emailController,
                errorMessage: "Gebruik een geldige e-mail adres",
                validator: 2,
                secureText: false,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8, top: 16),
                child: WhiteText(
                  text: "Vul hier uw wachtwoord in",
                  size: 14,
                ),
              ),
              //Password
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: _passwordController,
                errorMessage: "Gebruik minimaal 6 karakters",
                validator: 1,
                secureText: true,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 8, top: 16),
                child: WhiteText(
                  text: "Vul hier uw wachtwoord opnieuw in",
                  size: 14,
                ),
              ),
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
              // inloggen
              Container(
                margin: const EdgeInsets.only(left: 60, right: 60),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ButtonBackground(
                        text: 'Aanmelden',
                        size: 18,
                        onTap: registerAccount,
                        colorbackground: black,
                        dark: true,
                      ),
              ),
              SizedBox(
                height: 16,
              ),
              // terug
              Container(
                margin: const EdgeInsets.only(left: 60, right: 60),
                child: ButtonBackground(
                  text: 'Terug',
                  size: 18,
                  onTap: goBack,
                  colorbackground: red,
                  dark: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goBack() {
    Navigator.pop(context);
  }

  void registerAccount() {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      authService
          .signUpWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((value) {
        if (value != null) {
          /// mapping user data
          saveUserData();
        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  saveUserData() async {
    Map<String, String> userInfo = {
      "userName": _usernameController.text,
      "email": _emailController.text,
      "role": "user",
    };

    /// uploading user info to Firestore
    await DatabaseService().addUserData(userInfo).then((result) async {
      //storing user data in sharedpref
      await HelperFunctions.saveUserNameSharedPreference(
          _usernameController.text);
      await HelperFunctions.saveUserEmailSharedPreference(
          _emailController.text);
      await HelperFunctions.saveUserPasswordSharedPreference(
          _passwordController.text);

      await Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => LoginVisual("user")));
    });
  }
}
