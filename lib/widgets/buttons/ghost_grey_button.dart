import 'package:flutter/material.dart';

class GhostGreyButton extends StatelessWidget {
  const GhostGreyButton({this.text, this.onTap});

  final String? text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 3.5,
      ),
      child: Text(
        text!,
        style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 15,
            fontFamily: 'Sofia'),
      ),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }
}
