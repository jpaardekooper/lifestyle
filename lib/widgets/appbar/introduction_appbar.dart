import 'package:flutter/material.dart';

Widget introductionAppBar(BuildContext context, double value, bool leading) {
  return AppBar(
    title: const Text(
      "Introductie voor een gezondere levenstijl",
      style: TextStyle(fontSize: 14),
    ),
    centerTitle: true,
    automaticallyImplyLeading: leading,
    flexibleSpace: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      LinearProgressIndicator(
        value: value,
        backgroundColor: Colors.white,
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
        minHeight: 5,
      ),
    ]),
  );
}
