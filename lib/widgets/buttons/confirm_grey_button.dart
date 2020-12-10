import 'package:flutter/material.dart';

class ConfirmGreyButton extends StatelessWidget {
  const ConfirmGreyButton({this.text, this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RaisedButton(
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [const Color(0xFF2E5350), Theme.of(context).primaryColor],
            stops: [0.1, 0.1],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),

          //   color: Colors.blue,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          constraints: BoxConstraints(
              minWidth: 100,
              minHeight: 55.0,
              maxHeight: 55.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Sofia'),
          ),
        ),
      ),
    );
  }
}
