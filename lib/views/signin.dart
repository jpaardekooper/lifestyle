import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/widgets/login/login_visual.dart';
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';
import 'package:lifestylescreening/widgets/widgets.dart';
import 'package:lifestylescreening/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  AuthService authService;
  // DatabaseService _databaseMethods = DatabaseService();
  bool _isLoading;
  String test = "";
  String userName = "";
  bool rememberMe = false;

  @override
  void initState() {
    authService = AuthService();
    _isLoading = false;

    super.initState();
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
      });

  @override
  Widget build(BuildContext context) {
    //  final user = Provider.of<UserRepository>(context);
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      //resizeToAvoidBottomInset: false,

      key: _key,
      backgroundColor: Color.fromRGBO(255, 129, 128, 1),
      body: Form(
        key: _formKey,
        child: Container(
          //    width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 40),
          //     color:
          child: ListView(
            children: [
              SizedBox(
                height: 50,
              ),
              Center(child: LifestyleLogo(size: 50)),
              Center(
                child: Text(
                  "Log in met je account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              //Email
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 10, top: 10, left: 5),
                child: Text(
                  "Vul hier uw e-mail adres in: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                //return value if theres an value otherwise
                //return error mssge
                validator: (val) =>
                    validateEmail(val) ? null : "Enter correct email",
                decoration: inputDecoration(context),
                // onChanged: (val) {
                //   email = val;
                // },
              ),
              SizedBox(
                height: 6,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 10, top: 10, left: 5),
                child: Text(
                  "Vul hier uw wachtwoord in: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              //Password
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                validator: (val) {
                  return val.isEmpty ? "Enter correct password" : null;
                },
                decoration: inputDecoration(context),
                // onChanged: (val) {
                //   password = val;
                // },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Onthoudt mijn gegevens",
                    style: TextStyle(color: Colors.white, fontSize: 14),
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

              SizedBox(
                height: 16,
              ),
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
                              child: smallblackButton(context),
                              onTap: () {
                                signIn();
                              }),
                        ),
                      ),
                    ),

              SizedBox(
                height: 32,
              ),
              Align(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Material(
                    color: Color.fromRGBO(255, 129, 128, 1),
                    borderRadius: BorderRadius.circular(40),
                    child: InkWell(
                      splashColor: Colors.white,
                      borderRadius: BorderRadius.circular(40.0),
                      child: smallwhiteButton(context),
                      onTap: () {
                        Navigator.pop(context);
                        // final user = Provider.of<UserRepository>(context);
                        // await user.resetStatus();
                      },
                    ),
                  ),
                ),
              ),

              // SizedBox(
              //   height: 32,
              // ),
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

      String userRole;
      if (result != null) {
        // print("het resultaat is $result");

        // QuerySnapshot userInfoSnapshot =
        //     _databaseMethods.getUserInfo(_emailController.text);

        await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: _emailController.text)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) async {
            userName = result.data()["userName"];
            userRole = result.data()["role"];
          });
        });

        if (rememberMe) {
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
        }

        await HelperFunctions.saveUserNameSharedPreference(userName);
        await HelperFunctions.saveUserEmailSharedPreference(
            _emailController.text);
        await HelperFunctions.saveUserPasswordSharedPreference(
            _passwordController.text);
        await Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => LoginVisual(userRole)));
      } else {
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
    super.dispose();
  }
}
