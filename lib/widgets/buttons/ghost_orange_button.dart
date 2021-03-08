import 'package:flutter/material.dart';

class GhostOrangeButton extends StatelessWidget {
  const GhostOrangeButton({this.text, this.onTap});

  final String? text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      color: Colors.white,
      borderSide: BorderSide(
        color: Theme.of(context).accentColor,
        width: 3.5,
      ),
      child: Text(
        text!,
        style: TextStyle(
            color: Theme.of(context).accentColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            fontFamily: 'Sofia'),
      ),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }
}
