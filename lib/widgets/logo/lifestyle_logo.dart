import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LifestyleLogo extends StatelessWidget {
  LifestyleLogo({@required this.size, this.description});

  final double size;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Material(
          color: Colors.red,
          type: MaterialType.transparency, // likely needed
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'MHealth ',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 50,
                  decoration: TextDecoration.none),
              children: <TextSpan>[
                TextSpan(
                  text: '\n',
                ),
                TextSpan(
                  text: description ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: size,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          )),
    );
  }
}
