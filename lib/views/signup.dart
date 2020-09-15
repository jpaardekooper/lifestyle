import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String name, email, password;

  @override
  Widget build(BuildContext context) {
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        brightness: Brightness.light,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24),
          color: Color.fromRGBO(255, 129, 128, 1),
          child: Column(
            children: [
              Spacer(),
              TextFormField(
                //return value if theres an value otherwise reutrn error mssge
                validator: (val) {
                  return val.isEmpty ? "Enter correct Emailid" : null;
                },
                decoration: InputDecoration(hintText: "Email"),
                onChanged: (val) {
                  email = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              //Email
              TextFormField(
                //return value if theres an value otherwise reutrn error mssge
                validator: (val) {
                  return val.isEmpty ? "Enter correct Emailid" : null;
                },
                decoration: InputDecoration(hintText: "Email"),
                onChanged: (val) {
                  email = val;
                },
              ),
              SizedBox(
                height: 6,
              ),
              //Password
              TextFormField(
                //return value if theres an value otherwise reutrn error mssge
                validator: (val) {
                  return val.isEmpty ? "Enter correct password" : null;
                },
                decoration: InputDecoration(hintText: "Email"),
                onChanged: (val) {
                  email = val;
                },
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                alignment: Alignment.center,
                //depending on margin at line number 27 times 2
                width: MediaQuery.of(context).size.width - 48,
                child: Text("Sign in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Nog geen account? ",
                    style: TextStyle(fontSize: 15.5),
                  ),
                  Text(
                    "Regristreren",
                    style: TextStyle(
                        fontSize: 15.5, decoration: TextDecoration.underline),
                  ),
                ],
              ),
              //pushing the inlog buttons more above
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
