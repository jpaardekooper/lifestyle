import 'package:flutter/material.dart';

class GreyText extends StatelessWidget {
  const GreyText({this.text, this.size});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 30),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: size, color: Colors.black87),
      ),
    );
  }
}
