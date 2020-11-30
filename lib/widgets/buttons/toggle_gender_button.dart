import 'package:flutter/material.dart';

class ToggleGenderButton extends StatefulWidget {
  ToggleGenderButton({Key key, @required this.onTap}) : super(key: key);
  final Function(String) onTap;

  @override
  _ToggleGenderButtonState createState() => _ToggleGenderButtonState();
}

class _ToggleGenderButtonState extends State<ToggleGenderButton> {
  List<bool> isSelected;

  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
  }

  @override
  void dispose() {
    isSelected.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        borderColor: Theme.of(context).primaryColor,
        fillColor: Theme.of(context).primaryColor,
        borderWidth: 2,
        selectedBorderColor: Theme.of(context).primaryColor,
        selectedColor: Colors.white,
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
        constraints: BoxConstraints(
            minWidth: (MediaQuery.of(context).size.width - 40) / 2.2,
            maxWidth: (MediaQuery.of(context).size.width - 40) / 2.2,
            minHeight: 40),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Man',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Vrouw',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
        onPressed: (int index) {
          if (index == 0) {
            widget.onTap('male');
          } else {
            widget.onTap('female');
          }
          setState(() {
            for (int i = 0; i < isSelected.length; i++) {
              isSelected[i] = i == index;
            }
          });
        },
        isSelected: isSelected,
      ),
    );
  }
}
