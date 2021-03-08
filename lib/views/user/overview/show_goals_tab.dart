import 'package:flutter/material.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

class ShowGoalsTab extends StatefulWidget {
  const ShowGoalsTab({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  _ShowGoalsTabState createState() => _ShowGoalsTabState();
}

class _ShowGoalsTabState extends State<ShowGoalsTab> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            H1Text(
              text: "Jouw doelen",
            ),
            GestureDetector(
              onTap: widget.onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Alles inzien",
                    style: TextStyle(
                        fontSize: size.height * 0.024,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    HealthpointIcons.arrowRightIcon,
                    color: Theme.of(context).accentColor,
                    size: size.height * 0.024,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: size.height * 0.02,
        ),
        Container(
          height: size.height / 3,
          child: ListView(
            shrinkWrap: true,
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: size.width * 0.8,
                color: ColorTheme.extraLightGreen,
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              Container(
                width: size.width * 0.8,
                color: ColorTheme.extraLightGreen,
              ),
              SizedBox(
                width: size.width * 0.03,
              ),
              Container(
                width: size.width * 0.8,
                color: ColorTheme.extraLightGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
