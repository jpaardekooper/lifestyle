import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Ingredients extends StatelessWidget {
  Ingredients({this.amount, this.unit, this.product});

  final String amount;
  final String unit;
  final String product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(children: [
        Container(
          child: Icon(
            Icons.add,
            size: 22,
            color: Colors.black,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 2.0,
                offset: Offset(0.0, 1),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(width: 20),
        Text(
          amount + unit + " " + product,
          style: TextStyle(fontSize: 14),
        )
      ]),
    );
  }
}

class Method extends StatelessWidget {
  Method({this.step, this.instruction});

  final String step;
  final String instruction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step + ".",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Text(
              instruction,
              softWrap: true,
            ),
          )
        ],
      ),
    );
  }
}

class NutritionalValue extends StatelessWidget {
  NutritionalValue({this.amount, this.unit, this.name});

  final String amount;
  final String unit;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(amount + unit),
        ],
      ),
    );
  }
}
