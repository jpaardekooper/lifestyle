import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/text/button_text.dart';

class ButtonBackground extends StatelessWidget {
  const ButtonBackground(
      {this.text, this.size, this.onTap, this.colorbackground, this.dark});

  final String text;
  final double size;
  final VoidCallback onTap;
  final Color colorbackground;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorbackground,
      borderRadius: BorderRadius.circular(40),
      child: InkWell(
          borderRadius: BorderRadius.circular(40.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                  color: dark ? colorbackground : Colors.white, width: 2),
            ),
            alignment: Alignment.center,
            child: ButtonText(text, size),
          ),
          onTap: onTap),
    );
  }
}
