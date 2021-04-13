import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/survey_controller.dart';
import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/widgets/text/intro_grey_text.dart';

class RemoveSurvey extends StatelessWidget {
  RemoveSurvey({this.survey});
  final SurveyModel? survey;

  final SurveyController _surveyController = SurveyController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text("Waarschuwing", style: TextStyle(color: Colors.red)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("id: " + survey!.id!, style: TextStyle(color: Colors.white)),
          Text("Titel: " + survey!.title!,
              style: TextStyle(color: Colors.white)),
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
            text: 'Cancel',
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
          onPressed: () => _surveyController
              .removeSurvey(survey!.id)
              .then((value) => Navigator.of(context).pop()),
        )
      ],
    );
  }
}
