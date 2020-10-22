import 'package:flutter/material.dart';

class DarkText extends StatelessWidget {
  const DarkText({this.text, this.size});
  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 15),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontSize: size, color: Colors.black, fontWeight: FontWeight.w700),
      ),
    );
  }
}
