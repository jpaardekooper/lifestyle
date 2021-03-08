import 'package:flutter/material.dart';

class IntroLightGreyText extends StatelessWidget {
  const IntroLightGreyText({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        color: const Color(0xFFA2A4A3),
        fontFamily: 'Sofia',
        fontSize: MediaQuery.of(context).size.height * 0.020,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
