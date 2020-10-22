import 'package:flutter/material.dart';

class WhiteText extends StatelessWidget {
  const WhiteText({this.text, this.size});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: size, color: Colors.white, fontWeight: FontWeight.w700),
    );
  }
}
