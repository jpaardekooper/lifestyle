import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/buttons/button_background.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/login/login_visual.dart';
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';
import 'package:lifestylescreening/widgets/text/white_text.dart';
import 'package:lifestylescreening/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  static const Color black = Color.fromRGBO(72, 72, 72, 1);
  static const Color red = Color.fromRGBO(255, 129, 128, 1);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  AuthService authService = AuthService();

  bool _isLoading = false;
  String userName = "";
  bool rememberMe = false;
  String userRole;

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
      });

  void goBack() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: const Color.fromRGBO(255, 129, 128, 1),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 12),
              LifestyleLogo(
                size: 24,
                description: "Log in met je account",
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 12),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: WhiteText(
                  text: "Vul hier uw e-mail adres in: ",
                  size: 14,
                ),
              ),
              // username
              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                textcontroller: _emailController,
                errorMessage: "Geen geldige e-mail adres",
                validator: 1,
                secureText: false,
              ),
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: WhiteText(
                  text: "Vul hier uw wachtwoord in: ",
                  size: 14,
                ),
              ),
              // username
              CustomTextFormField(
                keyboardType: TextInputType.visiblePassword,
                textcontroller: _passwordController,
                errorMessage: "Geen geldige e-mail adres",
                validator: 1,
                secureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  WhiteText(
                    text: "Onthoudt mijn gegevens",
                    size: 14,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Checkbox(
                      value: rememberMe,
                      onChanged: _onRememberMeChanged,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 18),
              Container(
                margin: const EdgeInsets.only(left: 60, right: 60),
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ButtonBackground(
                        text: 'Aanmelden',
                        size: 18,
                        onTap: signIn,
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

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      dynamic result = await authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (result != null) {
        String henk = await authService.saveUserDetailsOnLogin(
            _emailController.text, _passwordController.text, rememberMe);

        if (henk != null) {
          await Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginVisual(henk)));
        } else {
          resetSignInPage();
        }
      } else {
        resetSignInPage();
      }
    }
  }

  void resetSignInPage() {
    setState(() {
      _isLoading = false;
      _key.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Er is iets mis gegaan probeer het nog eens",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    });
  }
}
