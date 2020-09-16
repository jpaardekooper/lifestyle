import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/text/button_text.dart';

class BackgroundDarkButton extends StatelessWidget {
  BackgroundDarkButton({this.text, this.size});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Color.fromRGBO(72, 72, 72, 1), width: 3),
        ),
        alignment: Alignment.center,
        //depending on margin at line number 27 times 2
        width: MediaQuery.of(context).size.width / 2.5,
        child: ButtonText(text, size));
  }
}
