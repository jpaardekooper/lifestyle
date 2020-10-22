import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationLogo extends StatelessWidget {
  BottomNavigationLogo({this.bottomAppIcon, this.bottomAppName, this.visible});

  final IconData bottomAppIcon;
  final String bottomAppName;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          bottomAppIcon,
          color: Colors.black,
        ),
        visible
            ? Container(
                padding: EdgeInsets.only(
                  bottom: 5, // space between underline and text
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.red, // Text colour here
                      width: 3.0, // Underline width
                    ),
                  ),
                ),
                child: Text(
                  bottomAppName,
                  style: TextStyle(fontSize: 12),
                ),
              )
            : Text(
                bottomAppName,
                style: TextStyle(fontSize: 12),
              ),
      ],
    );
  }
}
