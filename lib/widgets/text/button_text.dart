import 'dart:ffi';

import 'package:flutter/material.dart';

/// Template for the text for a button
class ButtonText extends StatelessWidget {
  ButtonText(this.text, this.size);

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(fontFamily: 'Nunito', fontSize: size, color: Colors.white),
    );
  }
}
