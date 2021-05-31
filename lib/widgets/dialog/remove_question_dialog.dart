import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class RemoveQuestion extends StatelessWidget {
  RemoveQuestion({this.category, this.question, this.totalQuestions});
  final CategoryModel? category;
  final QuestionModel? question;
  final int? totalQuestions;

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
          Text("id: " + question!.id!),
          Text("Titel: " + question!.question!),
          SizedBox(
            height: 10,
          ),
          Text("Druk op opslaan om door te gaan met verwijderen ",
              style: TextStyle(color: Colors.white)),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: IntroGreyText(
            text: 'Annuleren',
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        ElevatedButton(
          child: Text(
            'Verwijderen',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.020,
            ),
          ),
          style:
              ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
          onPressed: () => _questionnaireController
              .removeQuestion(category, question!.id, totalQuestions)
              .then((value) => Navigator.of(context).pop()),
        )
      ],
    );
  }
}
