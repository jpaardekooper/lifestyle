import 'package:flutter/material.dart';

class H3OrangeText extends StatelessWidget {
  const H3OrangeText({this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
        color: const Color(0xFFFCC88B),
        fontFamily: 'Sofia',
        fontSize: MediaQuery.of(context).size.height * 0.025,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
