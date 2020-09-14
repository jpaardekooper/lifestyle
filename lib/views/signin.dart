import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;

  @override
  Widget build(BuildContext context) {
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 24),
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
                //return value if theres an value otherwise reutrn error mssge
                validator: (val) {
                  return val.isEmpty ? "Enter correct Emailid" : null;
                },
                decoration: inputDecoration(context),
                onChanged: (val) {
                  email = val;
                },
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
                //return value if theres an value otherwise reutrn error mssge
                validator: (val) {
                  return val.isEmpty ? "Enter correct password" : null;
                },
                decoration: inputDecoration(context),
                onChanged: (val) {
                  password = val;
                },
              ),
              Spacer(flex: 1),
              InkWell(
                onTap: () {
                  print("Hello");
                },
                child: smallblackButton(context),
              ),
              SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: smallwhiteButton(context),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
