import 'package:flutter/material.dart';

class H3OrangeText extends StatelessWidget {
  const H3OrangeText({this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: const Color(0xFFFCC88B),
        fontFamily: 'Sofia',
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
