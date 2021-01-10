import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/firebase_user.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class SurveyComplete extends StatelessWidget {
  const SurveyComplete(
      {Key key,
      @required this.surveyResult,
      @required this.user,
      @required this.surveyTitle})
      : super(key: key);
  final SurveyResultModel surveyResult;
  final AppUser user;
  final String surveyTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          H1Text(text: "Hoe goed zorg je voor jezelf?"),
          SizedBox(
            height: 10,
          ),
          H2Text(
            text: "Weet het!",
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              "In dit deel van het onderzoek laten we je zien hoe goed je voor jezelf zorgt. We geven dit aan met een puntenaantal per onderdeel (bewegen, roken, alcohol, voeding en ontspanning). Het einddoel is om zo min mogelijk punten te behalen. Hoe meer punten, hoe meer ruimte voor verbetering."),
          SizedBox(
            height: 10,
          ),
          Text("Uw scores zijn:"),
          SizedBox(
            height: 10,
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: surveyResult.categories.length,
            itemBuilder: (BuildContext ctx, index) {
              return Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    height: 20,
                    child: BodyText(text: surveyResult.categories[index]),
                  ),
                  Text("${surveyResult.points_per_category[index]}")
                ],
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          BodyText(
              text: "Totaal aantal punten \t ${surveyResult.total_points}"),
          SizedBox(
            height: 20,
          ),
          H2Text(
            text: "Verbeter het!",
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Een goede leefstijl verkleint het risico op overgewicht en ziekten zoals hart- en vaatziekten, kanker, enzovoort. Een goede leefstijl houdt in: voldoende bewegen, niet roken, geen of weinig alcohol, goede eetgewoontes en voldoende slaap of ontspanning.",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 40,
          ),
          Center(child: H2Text(text: "Bedankt voor uw deelname!")),
          Padding(
            padding: EdgeInsets.all(40),
            child: ConfirmOrangeButton(
              text: "Terug",
              onTap: (() {
                QuestionnaireController()
                    .setSurveyToFalse(surveyTitle, user, surveyResult);
                Navigator.of(context).pop();
              }),
            ),
          ),
        ],
      ),
    );
  }
}
