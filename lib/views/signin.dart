import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/views/homescreen.dart';
import 'package:lifestylescreening/widgets/widgets.dart';
import 'package:lifestylescreening/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthService authService;
  DatabaseService _databaseMethods = DatabaseService();
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
                      "Log in met je account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Spacer(flex: 1),
                    //Email
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Vul hier uw e-mail adres in: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
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
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Vul hier uw wachtwoord in: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
                      // onChanged: (val) {
                      //   password = val;
                      // },
                    ),
                    Text(test == "" ? "" : test),
                    SizedBox(
                      height: 25,
                    ),

                    Material(
                      color: Color.fromRGBO(72, 72, 72, 1),
                      borderRadius: BorderRadius.circular(40),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(40.0),
                          child: smallblackButton(context),
                          onTap: () {
                            signIn();
                          }),
                    ),

                    SizedBox(
                      height: 24,
                    ),

                    Material(
                      color: Color.fromRGBO(255, 129, 128, 1),
                      borderRadius: BorderRadius.circular(40),
                      child: InkWell(
                        splashColor: Colors.white,
                        borderRadius: BorderRadius.circular(40.0),
                        child: smallwhiteButton(context),
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

  String test = "";

  signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      dynamic result = await authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);

      if (result != null) {
        print("het resultaat is $result");

        String userName;

        // QuerySnapshot userInfoSnapshot =
        //     _databaseMethods.getUserInfo(_emailController.text);

        await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: _emailController.text)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) async {
            userName = result.data()["userName"];

            await HelperFunctions.saveUserLoggedInSharedPreference(true);
            await HelperFunctions.saveUserNameSharedPreference(userName);
            await HelperFunctions.saveUserEmailSharedPreference(
                _emailController.text);
            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomeContainer()));
          });
        });
      } else {
        setState(() {
          _isLoading = false;
          test = "wrong credential";
        });
      }
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
    super.dispose();
  }
}
