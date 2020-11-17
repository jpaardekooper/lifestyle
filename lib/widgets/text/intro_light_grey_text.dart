import 'package:flutter/material.dart';

class IntroLightGreyText extends StatelessWidget {
  const IntroLightGreyText({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFFA2A4A3),
        fontFamily: 'Sofia',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
