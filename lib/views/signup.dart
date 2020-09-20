import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/services/auth.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/views/homescreen.dart';
import 'package:lifestylescreening/widgets/buttons/background_dark_button.dart';
import 'package:lifestylescreening/widgets/buttons/background_white_button.dart';
import 'package:lifestylescreening/widgets/widgets.dart';

import 'home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordChecker = TextEditingController();

  AuthService authService;
  bool _isLoading;

  @override
  void initState() {
    authService = AuthService();
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? Container(
              color: Color.fromRGBO(255, 129, 128, 1),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color.fromRGBO(72, 72, 72, 1),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          : Form(
              key: _formKey,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 40),
                color: Color.fromRGBO(255, 129, 128, 1),
                child: Column(
                  children: [
                    Spacer(flex: 2),
                    appName(context),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Meld je aan voor een nieuw account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Spacer(flex: 1),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Gebruikersnaam: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    TextFormField(
                      controller: _usernameController,
                      //return value if theres an value otherwise reutrn error mssge
                      validator: (val) {
                        return val.isEmpty ? "Enter gebruikersnaam" : null;
                      },
                      decoration: inputDecoration(context),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    //email
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Vul hier uw e-mail adres in: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      //return value if theres an value otherwise reutrn error mssge
                      validator: (val) =>
                          validateEmail(val) ? null : "Enter correct email",
                      decoration: inputDecoration(context),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    //pass
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Vul hier uw wachtwoord in: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    //Password
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      //return value if theres an value otherwise reutrn error mssge
                      validator: (val) {
                        return val.isEmpty ? "Enter correct password" : null;
                      },
                      decoration: inputDecoration(context),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Vul hier uw wachtwoord in opnieuw in: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    //Password
                    TextFormField(
                      obscureText: true,
                      controller: _passwordChecker,
                      //return value if theres an value otherwise reutrn error mssge
                      validator: (val) {
                        return val != _passwordController.text
                            ? "Password komt niet overeen"
                            : null;
                      },
                      decoration: inputDecoration(context),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // inloggen
                    Material(
                      color: Color.fromRGBO(72, 72, 72, 1),
                      borderRadius: BorderRadius.circular(40),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(40.0),
                          child:
                              BackgroundDarkButton(text: "Aanmelden", size: 20),
                          onTap: () {
                            signUp();
                          }),
                    ),

                    SizedBox(
                      height: 24,
                    ),
                    // terug
                    Material(
                      color: Color.fromRGBO(255, 129, 128, 1),
                      borderRadius: BorderRadius.circular(40),
                      child: InkWell(
                        splashColor: Colors.white,
                        borderRadius: BorderRadius.circular(40.0),
                        child: BackgroundWhiteButton(text: "Terug", size: 20),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Spacer(flex: 2),
                  ],
                ),
              ),
            ),
    );
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .signUpWithEmailAndPassword(
              _emailController.text, _passwordController.text)
          .then((value) {
        if (value != null) {
          /// uploading user info to Firestore
          Map<String, String> userInfo = {
            "userName": _usernameController.text,
            "email": _emailController.text,
          };
          DatabaseService().addUserData(userInfo).then((result) {});

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              _usernameController.text);
          print("${_usernameController.text} username saved");

          HelperFunctions.saveUserEmailSharedPreference(_emailController.text);
          print("${_emailController.text} user email saved");

          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => HomeContainer()));
        }
      });
    }
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordChecker.dispose();
    super.dispose();
  }
}
