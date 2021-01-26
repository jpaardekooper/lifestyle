import 'package:flutter/material.dart';

class IntroGreyText extends StatelessWidget {
  const IntroGreyText({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF253635),
        fontFamily: 'Sofia',
        fontSize: MediaQuery.of(context).size.height * 0.020,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
