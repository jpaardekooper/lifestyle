import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylescreening/services/auth.dart';
import 'package:lifestylescreening/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordChecker = TextEditingController();

  AuthService authService;

  @override
  void initState() {
    authService = AuthService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 30),
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
                  "Vul hier uw e-mail adres in: ",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              TextFormField(
                controller: _emailController,
                //return value if theres an value otherwise reutrn error mssge
                validator: (val) {
                  return val.isEmpty ? "Enter email naam" : null;
                },
                decoration: inputDecoration(context),
              ),
              SizedBox(
                height: 6,
              ),
              //Email
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
                    child: smallblackButton(context),
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        await authService
                            .register(
                                _emailController.text, _passwordController.text)
                            .then((value) {
                          if (value != null) {
                            Navigator.pop(context);
                          }
                        });
                      }

                      ;
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordChecker.dispose();
    super.dispose();
  }
}
