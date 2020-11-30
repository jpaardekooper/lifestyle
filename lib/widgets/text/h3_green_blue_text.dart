import 'package:flutter/material.dart';

class H3GreenBlueText extends StatelessWidget {
  const H3GreenBlueText({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: const Color(0xFF73B39A),
        fontFamily: 'Sofia',
        fontSize: MediaQuery.of(context).size.height * 0.02,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
