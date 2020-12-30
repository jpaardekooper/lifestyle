import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/models/question_model.dart';

class RemoveQuestion extends StatelessWidget {
  RemoveQuestion({this.category, this.question, this.totalQuestions});
  final CategoryModel category;
  final QuestionModel question;
  final int totalQuestions;

  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Waarschuwing", style: TextStyle(color: Colors.red)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("id: " + question.id),
          Text("Titel: " + question.question),
          SizedBox(
            height: 10,
          ),
          Text("Druk op opslaan om door te gaan met verwijderen ",
              style: TextStyle(color: Colors.white)),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context, null),
        ),
        RaisedButton(
          child: Text('Opslaan'),
          onPressed: () => _questionnaireController
              .removeQuestion(category, question.id, totalQuestions)
              .then((value) => Navigator.of(context).pop()),
        )
      ],
    );
  }
}
