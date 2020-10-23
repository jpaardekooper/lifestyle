import 'package:flutter/material.dart';

class DarkText extends StatelessWidget {
  const DarkText({this.text, this.size});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: size, color: Colors.black, fontWeight: FontWeight.w700),
    );
  }
}
