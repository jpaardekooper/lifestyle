import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/views/admin/dashboard.dart';
import 'package:lifestylescreening/views/home.dart';
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';

class LoginVisual extends StatelessWidget {
  LoginVisual(this.role);
  final String role;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      if (role == "user") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()),
            (Route<dynamic> route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Dashboard()),
            (Route<dynamic> route) => false);
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => Dashboard()));
      }
    });
    return Container(
      color: Color.fromRGBO(255, 129, 128, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          LifestyleLogo(
            size: 20,
          ),
          Text(
            "welkom",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 50,
                decoration: TextDecoration.none),
          ),
          Container(
            color: Color.fromRGBO(255, 129, 128, 1),
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Color.fromRGBO(72, 72, 72, 1),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
