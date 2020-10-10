import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LifestyleLogo extends StatelessWidget {
  LifestyleLogo({
    @required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: Material(
        type: MaterialType.transparency, // likely needed
        child: Text(
          'MHealth',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: size,
              decoration: TextDecoration.none),
        ),
      ),
    );
  }
}
