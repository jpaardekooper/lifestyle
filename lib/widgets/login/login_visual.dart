import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';

class LoginVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
