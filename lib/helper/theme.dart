import 'package:flutter/material.dart';

class MyThemeData {
  static InputDecoration themedecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.black54,
        fontFamily: 'OverpassRegular',
      ),
    );
  }
}
