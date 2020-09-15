import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/text/button_text.dart';

class BackgroundWhiteButton extends StatelessWidget {
  BackgroundWhiteButton({this.text, this.size});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          //    color: Color.fromRGBO(255, 129, 128, 1),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white, width: 3),
        ),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 2.5,
        child: ButtonText(text, size));
  }
}
