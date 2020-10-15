import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NutritionalValue extends StatelessWidget {
  NutritionalValue({this.amount, this.unit, this.name});

  final String amount;
  final String unit;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(name + " " + amount + unit));
  }
}
