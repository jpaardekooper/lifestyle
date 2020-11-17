import 'package:flutter/material.dart';

class H1Text extends StatelessWidget {
  const H1Text({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF253635),
        fontFamily: 'Sofia',
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
