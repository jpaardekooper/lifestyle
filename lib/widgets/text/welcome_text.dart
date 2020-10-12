import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Hello $name",
          style: TextStyle(color: Colors.red[200]),
        )
      ],
    );
  }
}
