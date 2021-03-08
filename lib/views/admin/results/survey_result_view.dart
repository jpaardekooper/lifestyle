import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/result_controller.dart';
import 'package:lifestylescreening/models/survery_answer_model.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/lifestyle_text.dart';

import '../../../healthpoint_icons.dart';

class SurveyResultView extends StatefulWidget {
  SurveyResultView({this.resultId, this.category});

  final String? resultId;
  final String? category;

  @override
  _SurveyResultViewState createState() => _SurveyResultViewState();
}

class _SurveyResultViewState extends State<SurveyResultView> {
  Widget showQuestionAndAnswer(BuildContext context) {
    return FutureBuilder<List<SurveyAnswerModel>>(
      future:
          ResultController().getSurveyAnswers(widget.resultId, widget.category),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text("Geen data gevonden"),
          );
        } else {
          final List<SurveyAnswerModel> _answerList = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _answerList.first.answer!.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      text:
                          // ignore: lines_longer_than_80_chars
                          "Vraag: ${index + 1}.  \t ${_answerList.first.question![index]}",
                    ),
                    SizedBox(height: 10),
                    LifestyleText(
                      text: _answerList.first.answer![index],
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(HealthpointIcons.arrowLeftIcon),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
        title: H1Text(
          text: widget.category,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width < 1300
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width - 310,
        child: showQuestionAndAnswer(context),
      ),
    );
  }
}
