import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/widgets/web/download_app.dart';

class StartSurvey extends StatefulWidget {
  @override
  _StartSurveyState createState() => _StartSurveyState();
}

class _StartSurveyState extends State<StartSurvey> {
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();
  String selectedAnswer;
  int nextQuestionInQue;
  int _tempNextQuestion;

  double questionAnsweredValue;
  double valueforquestion;
  int calculateDifference;
  List<QuestionModel> _questionList;

  @override
  void initState() {
    nextQuestionInQue = 1;
    selectedAnswer = "";
    questionAnsweredValue = 0.0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void nextQuestion() {
    setState(() {
      calculateDifference = _tempNextQuestion - nextQuestionInQue;

      nextQuestionInQue = _tempNextQuestion;
      selectedAnswer = "";

      //update linearprogress indicator with the correct value
      questionAnsweredValue += (valueforquestion * calculateDifference);
    });
  }

  Widget fetchQuestion(BuildContext context) {
    return FutureBuilder<List<QuestionModel>>(
      future: _questionnaireController.fetchDTDQuestion(),
      builder: (context, snapshot) {
        _questionList = snapshot.data;
        if (_questionList == null || _questionList.isEmpty) {
          return CircularProgressIndicator();
        } else {
          valueforquestion = 1.0 / _questionList.length.toDouble();

//get the correct question from the list
          var question =
              _questionList.singleWhere((i) => i.order == nextQuestionInQue);
          return Column(
            children: [
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 700,
                child: LinearProgressIndicator(
                  value: questionAnsweredValue,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(0, 178, 205, 1),
                  ),
                  minHeight: 20,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                  question.order.toString() + ". " + question.question,
                  style: TextStyle(fontSize: 28),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              fetchAnswer(question.id),
            ],
          );
        }
      },
    );
  }

  Widget fetchAnswer(String questionId) {
    return FutureBuilder<List<AnswerModel>>(
        future: _questionnaireController.fetchAnswer(questionId),
        builder: (context, snapshot) {
          var answer = snapshot.data;
          if (answer == null || answer.isEmpty) {
            return CircularProgressIndicator();
          }

          return SizedBox(
            width: 700,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: answer.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RadioListTile(
                      value: answer[index].option,
                      groupValue: selectedAnswer,
                      activeColor: Colors.white,
                      title: Text(answer[index].option),
                      onChanged: (value) {
                        setState(() {
                          selectedAnswer = value;
                          _tempNextQuestion = answer[index].next;
                        });
                      },
                      selected: selectedAnswer == answer[index].option,
                    ),
                  ],
                );
              },
            ),
          );
        });
  }

  Widget showNextQuestionButton(BuildContext context) {
    return selectedAnswer == ""
        ? Padding(
            padding: const EdgeInsets.only(top: 45.0),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: FlatButton(
              height: 20,
              color: Colors.blue,
              onPressed: () => nextQuestion(),
              child: Icon(Icons.check),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: nextQuestionInQue != 0
            ? Column(
                children: [
                  fetchQuestion(context),
                  showNextQuestionButton(context),
                ],
              )
            : DownloadApp());
  }
}
