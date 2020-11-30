import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/interest_model.dart';

class SelectedInterestCard extends StatefulWidget {
  SelectedInterestCard({
    Key key,
    @required this.onTap,
    @required this.interest,
  }) : super(key: key);

  final InterestModel interest;
  final Function(bool, InterestModel) onTap;

  @override
  _SelectedInterestCardState createState() => _SelectedInterestCardState();
}

class _SelectedInterestCardState extends State<SelectedInterestCard> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(18.0)),
          onTap: () {
            setState(() {
              selected = !selected;
            });

            widget.onTap(selected, widget.interest);
          },
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.interest.interest),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      FlutterLogo(
                        size: 50,
                      ),
                      //simple gesture hack
                      SizedBox(
                        height: 0,
                        child: Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            autofocus: false,
                            onChanged: (value) => null,
                            activeColor: Theme.of(context).primaryColor,
                            value: selected,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
