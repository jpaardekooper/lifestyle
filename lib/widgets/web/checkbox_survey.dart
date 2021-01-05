import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/answer_model.dart';

class CheckBoxSurvey extends StatefulWidget {
  CheckBoxSurvey(
      {Key key,
      @required this.answer,
      @required this.selected,
      @required this.controller,
      @required this.function})
      : super(key: key);
  final AnswerModel answer;
  final TextEditingController controller;
  final Function(int) function;
  bool selected;

  @override
  _CheckBoxSurveyState createState() => _CheckBoxSurveyState();
}

class _CheckBoxSurveyState extends State<CheckBoxSurvey> {
  List<String> answers = [];

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(widget.answer.option),
      value: widget.selected,
      onChanged: (value) {
        setState(() {
          widget.selected = value;
          if (value) {
            answers.add(widget.answer.option);
          } else {
            answers.remove(widget.answer.option);
          }
          for (int i = 0; i < answers.length; i++) {
            widget.controller.text += answers[i] + ",";
          }
          widget.function(widget.answer.next);
        });
      },
      selected: widget.selected,
    );
  }
}
