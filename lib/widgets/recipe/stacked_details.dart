import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/recipe/row_with_icons.dart';
import 'package:lifestylescreening/widgets/text/dark_text.dart';
import 'package:lifestylescreening/widgets/text/white_text.dart';

class StackedDetails extends StatelessWidget {
  StackedDetails(
      {this.expandedHeight, this.shrinkOffset, this.name, this.colored});

  final double expandedHeight;
  final double shrinkOffset;
  final String name;
  final bool colored;
  final Color red = const Color.fromRGBO(255, 129, 128, 0.9);

  Opacity showDetails() {
    return Opacity(
      opacity: (1 - shrinkOffset / expandedHeight),
      child: Material(
        elevation: 10,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: expandedHeight / 5,
              decoration: BoxDecoration(
                color: colored ? red : Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  colored
                      ? WhiteText(
                          text: name,
                          size: 18,
                        )
                      : DarkText(
                          text: name,
                          size: 18,
                        )
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
              ),
              height: expandedHeight / 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RowWithIconAndText(
                    icon: Icon(
                      Icons.star,
                      color: Colors.orange[300],
                      size: 16,
                    ),
                    text: "4.3 ",
                  ),
                  RowWithIconAndText(
                    icon: Icon(
                      Icons.timer,
                      color: Colors.blue,
                      size: 16,
                    ),
                    text: "40 min",
                  ),
                  RowWithIconAndText(
                    icon: Icon(
                      Icons.food_bank,
                      color: Colors.red,
                      size: 16,
                    ),
                    text: "makkelijk",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return colored
        ? Positioned(
            top: expandedHeight / 1.252 - shrinkOffset,
            left: colored ? 70 : 50,
            right: colored ? 70 : 50,
            child: showDetails(),
          )
        : showDetails();
  }
}
