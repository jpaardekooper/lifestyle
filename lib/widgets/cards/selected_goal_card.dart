import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/goals_model.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class SelectedGoalCard extends StatefulWidget {
  SelectedGoalCard({Key key, @required this.onTap, @required this.goal})
      : super(key: key);
  final Function(bool, GoalsModel) onTap;
  final GoalsModel goal;

  @override
  _SelectedGoalCardState createState() => _SelectedGoalCardState();
}

class _SelectedGoalCardState extends State<SelectedGoalCard> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        elevation: 5,
        child: InkWell(
          borderRadius: BorderRadius.circular(18.0),
          onTap: () {
            setState(() {
              selected = !selected;
            });
            widget.onTap(selected, widget.goal);
          },
          child: Container(
            height: size.height * 0.15,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(
                      selected
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Theme.of(context).primaryColor,
                      size: 40,
                    ),
                    SizedBox(
                      width: size.width * 0.025,
                    ),
                    SizedBox(
                        width: size.width / 2.5,
                        child:
                            Wrap(children: [H2Text(text: widget.goal.goals)])),
                  ],
                ),
                FlutterLogo(
                  size: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
