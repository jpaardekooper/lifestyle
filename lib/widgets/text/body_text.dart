import 'package:flutter/material.dart';

class BodyText extends StatelessWidget {
  const BodyText({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Text(
        text!,
        style: TextStyle(
          color: const Color(0xFF253635),
          fontFamily: 'Sofia',
          fontSize: MediaQuery.of(context).size.height * 0.025,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
