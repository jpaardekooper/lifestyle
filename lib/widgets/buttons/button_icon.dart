import 'package:flutter/material.dart';

class ButtonIcon extends StatelessWidget {
  const ButtonIcon(
      {@required this.icon,
      @required this.showText,
      @required this.onTap,
      this.backgroundText});
  final Icon icon;
  final bool showText;
  final VoidCallback onTap;
  final String backgroundText;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 50.0, minHeight: 50.0),
      onPressed: () {},
      child: showText
          ? Text(
              backgroundText,
              style: TextStyle(
                color: Colors.black,
              ),
            )
          : icon,
      elevation: 2.0,
      fillColor: Colors.white,
      shape: CircleBorder(),
    );
  }
}
