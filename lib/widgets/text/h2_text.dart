import 'package:flutter/material.dart';

class H2Text extends StatelessWidget {
  const H2Text({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontFamily: 'Sofia',
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
