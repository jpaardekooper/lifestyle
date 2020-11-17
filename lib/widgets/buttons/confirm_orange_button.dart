import 'package:flutter/material.dart';

class ConfirmOrangeButton extends StatelessWidget {
  const ConfirmOrangeButton({this.text, this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: 70,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [const Color(0xFFD07004), Theme.of(context).accentColor],
            stops: [0.1, 0.1],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          color: Colors.blue,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
              fontFamily: 'Sofia'),
        ),
      ),
    );
  }
}
