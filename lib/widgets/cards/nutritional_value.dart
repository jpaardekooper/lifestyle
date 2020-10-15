import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NutritionalValue extends StatelessWidget {
  NutritionalValue({this.amount, this.unit, this.name});

  String amount = "";
  String unit = "";
  String name = "";

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(name + " " + amount + unit));
  }
}
