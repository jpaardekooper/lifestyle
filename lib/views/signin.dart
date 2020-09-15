import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/widgets.dart';
import 'package:lifestylescreening/services/auth.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService authService;
  final _formKey = GlobalKey<FormState>();
  String email, password;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Scaffold is used to utilize all the material widgets
    return Scaffold(
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
                controller: _passwordController,
                //return value if theres an value otherwise reutrn error mssge
                validator: (val) {
                  return val.isEmpty ? "Enter correct password" : null;
                },
                decoration: inputDecoration(context),
                onChanged: (val) {
                  password = val;
                },
              ),
              SizedBox(
                height: 25,
              ),
              Material(
                color: Color.fromRGBO(72, 72, 72, 1),
                borderRadius: BorderRadius.circular(40),
                child: InkWell(
                    borderRadius: BorderRadius.circular(40.0),
                    child: smallblackButton(context),
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        await authService.signInWithEmailAndPassword(
                            _emailController.text, _passwordController.text);
                      }
                      ;
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
