import 'package:flutter/material.dart';

class H2Text extends StatelessWidget {
  const H2Text({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Text(
        text!,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontFamily: 'Sofia',
            fontSize: MediaQuery.of(context).size.height * 0.025,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none),
      ),
    );
  }
}
