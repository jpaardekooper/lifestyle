import 'package:flutter/material.dart';

class RowWithIconAndText extends StatelessWidget {
  const RowWithIconAndText({
    this.icon,
    this.text,
  });
  final Icon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      icon,
      SizedBox(
        width: 5,
      ),
      Text(
        text,
        style: TextStyle(fontSize: 10),
      )
    ]);
  }
}
