import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/services/auth.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/widgets/buttons/background_dark_button.dart';
import 'package:lifestylescreening/widgets/buttons/background_white_button.dart';
import 'package:lifestylescreening/widgets/login/login_visual.dart';
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';
import 'package:lifestylescreening/widgets/widgets.dart';

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
      // resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(255, 129, 128, 1),
      body: Form(
        key: _formKey,
        child: Container(
          //    width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: ListView(
            children: [
              SizedBox(
                height: 16,
              ),
              Center(child: LifestyleLogo(size: 50)),
              SizedBox(
                height: 6,
              ),
              Center(
                child: Text(
                  "Meld je aan voor een nieuw account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 10, top: 10, left: 5),
                child: Text(
                  "Gebruikersnaam: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _usernameController,
                keyboardType: TextInputType.visiblePassword,
                //return value if theres an value otherwise reutrn error
                // mssge
                validator: (val) {
                  return val.isEmpty ? "Enter gebruikersnaam" : null;
                },
                decoration: inputDecoration(context),
              ),
              SizedBox(
                height: 16,
              ),
              //email
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 10, top: 10, left: 5),
                child: Text(
                  "Vul hier uw e-mail adres in: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                //return value if theres an value otherwise reutrn
                //error mssge
                validator: (val) =>
                    validateEmail(val) ? null : "Enter correct email",
                decoration: inputDecoration(context),
              ),
              SizedBox(
                height: 16,
              ),
              //pass
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 10, top: 10, left: 5),
                child: Text(
                  "Vul hier uw wachtwoord in: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              //Password
              TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: true,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                //return value if theres an value otherwise reutrn
                // error mssge
                validator: (val) {
                  return val.isEmpty ? "Enter correct password" : null;
                },
                decoration: inputDecoration(context),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 10, top: 10, left: 5),
                child: Text(
                  "Vul hier uw wachtwoord in opnieuw in: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              //Password
              TextFormField(
                textInputAction: TextInputAction.done,
                obscureText: true,
                controller: _passwordChecker,
                keyboardType: TextInputType.visiblePassword,
                //return value if theres an value otherwise reutrn
                //error mssge
                validator: (val) {
                  return val != _passwordController.text
                      ? "Password komt niet overeen"
                      : null;
                },
                decoration: inputDecoration(context),
              ),
              SizedBox(
                height: 30,
              ),
              // inloggen
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Align(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Material(
                          color: Color.fromRGBO(72, 72, 72, 1),
                          borderRadius: BorderRadius.circular(40),
                          child: InkWell(
                              borderRadius: BorderRadius.circular(40.0),
                              child: BackgroundDarkButton(
                                  text: "Aanmelden", size: 18),
                              onTap: () {
                                signUp();
                              }),
                        ),
                      ),
                    ),

              SizedBox(
                height: 16,
              ),
              // terug
              Align(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Material(
                    color: Color.fromRGBO(255, 129, 128, 1),
                    borderRadius: BorderRadius.circular(40),
                    child: InkWell(
                      splashColor: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                      child: BackgroundWhiteButton(text: "Terug", size: 18),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
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
            "role": "user",
          };
          DatabaseService().addUserData(userInfo).then((result) {
            HelperFunctions.saveUserLoggedInSharedPreference(true);
            HelperFunctions.saveUserNameSharedPreference(
                _usernameController.text);
            //   print("${_usernameController.text} username saved");

            HelperFunctions.saveUserEmailSharedPreference(
                _emailController.text);

            HelperFunctions.saveUserPasswordSharedPreference(
                _passwordController.text);

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginVisual("user")));
          });

          // HelperFunctions.saveUserLoggedInSharedPreference(true);

        }
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
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
