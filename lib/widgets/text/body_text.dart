import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  const BodyText({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color(0xFF253635),
        fontFamily: 'Sofia',
        fontSize: 17.5,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
