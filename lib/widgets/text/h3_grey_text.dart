import 'package:flutter/material.dart';

class H3GreyText extends StatelessWidget {
  const H3GreyText({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFFA2A4A3),
        fontFamily: 'Sofia',
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
