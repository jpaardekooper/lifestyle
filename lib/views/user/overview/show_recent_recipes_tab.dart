import 'package:flutter/material.dart';
import 'package:lifestylescreening/healthpoint_icons.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

class ShowRecentRecipesTab extends StatefulWidget {
  ShowRecentRecipesTab({Key key, this.onTap}) : super(key: key);
  final VoidCallback onTap;
  @override
  _ShowRecentRecipesTabState createState() => _ShowRecentRecipesTabState();
}

class _ShowRecentRecipesTabState extends State<ShowRecentRecipesTab> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              H1Text(
                text: "Laatste recepten",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Alles inzien",
                    style: TextStyle(
                        fontSize: size.height * 0.021,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    HealthpointIcons.arrowRightIcon,
                    color: Theme.of(context).accentColor,
                    size: size.height * 0.021,
                  ),
                ],
              ),
            ],
          ),
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
