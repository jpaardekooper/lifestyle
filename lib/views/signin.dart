import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/auth_controller.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/widgets/buttons/button_background.dart';
import 'package:lifestylescreening/widgets/forms/custom_textformfield.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_widget.dart';
import 'package:lifestylescreening/widgets/login/login_visual.dart';
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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
  AuthController _authController = AuthController();

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
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            width: kIsWeb
                ? MediaQuery.of(context).size.width / 2.5
                : MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              children: [
                LifestyleLogo(
                  size: 24,
                  description: "Log in met je account",
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 12),
                Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text("Vul hier uw e-mail adres in")),
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
                    child: Text("Vul hier uw wachtwoord in")),
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
                    Text("Remember me"),
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
      ),
    );
  }

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      AppUser result = await _authController.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
      if (result != null) {
        await _authController.saveUserDetailsOnLogin(
            result, _passwordController.text, rememberMe);

        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InheritedDataProvider(
              data: result,
              child: LoginVisual(),
            ),
          ),
        );
      } else {
        resetSignInPage();
      }
    } else {
      resetSignInPage();
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
