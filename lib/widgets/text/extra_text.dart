import 'package:flutter/material.dart';

class ExtraText extends StatelessWidget {
  const ExtraText({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFFA2A4A3),
        fontFamily: 'Sofia',
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
