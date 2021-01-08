import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/views/web/landing_page_app.dart';
import 'package:lifestylescreening/widgets/bottom/tutorial_buttons.dart';
import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/forms/custom_answerfield.dart';
import 'package:lifestylescreening/widgets/painter/top_large_wave_painter.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/web/download_app.dart';
import 'package:lifestylescreening/widgets/web/checkbox_survey.dart';

class StartSurvey extends StatefulWidget {
  const StartSurvey({Key key, @required this.docId}) : super(key: key);
  final String docId;
  @override
  _StartSurveyState createState() => _StartSurveyState();
}

class _StartSurveyState extends State<StartSurvey> {
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  final _formKey = GlobalKey<FormState>();
  String selectedAnswer;
  int nextQuestionInQue;
  int _tempNextQuestion;

  double questionAnsweredValue;
  double valueforquestion;
  int calculateDifference;
  List<QuestionModel> _questionList;
  String currentQuestion = "";

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

  //vraag 0 = bedankt voor de app
  //vraag 8 = Overleg alvorens met een specialist om de app te downloaden

  nextQuestion() async {
    if (_formKey.currentState.validate()) {
      Map<String, dynamic> surveyData = {
        "question": currentQuestion,
        "answer": controller.text,
      };

      await _questionnaireController.setDTDSurveyResults(
          widget.docId, surveyData);

      setState(() {
        calculateDifference = _tempNextQuestion - nextQuestionInQue;

        nextQuestionInQue = _tempNextQuestion;
        selectedAnswer = "";
        controller.text = "";
        currentQuestion = "";

        //update linearprogress indicator with the correct value
        questionAnsweredValue += (valueforquestion * calculateDifference);
      });
    }
  }

  TextEditingController controller = TextEditingController();

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

          currentQuestion = question.question;

          return Column(
            children: [
              LinearProgressIndicator(
                value: questionAnsweredValue,
                backgroundColor: Colors.grey[100],
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorTheme.accentOrange),
                minHeight: 20,
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: H1Text(
                  text: "${question.order}. ${question.question}",
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

  void setNextQuestion(int number) {
    _tempNextQuestion = number;
  }

  Widget fetchAnswer(String questionId) {
    return FutureBuilder<List<AnswerModel>>(
      future: _questionnaireController.fetchDTDAnswer(questionId),
      builder: (context, snapshot) {
        var answer = snapshot.data;
        if (answer == null || answer.isEmpty) {
          return CircularProgressIndicator();
        }
        List<bool> values = [];

        return Padding(
          padding: MediaQuery.of(context).size.width < 900
              ? EdgeInsets.all(20)
              : EdgeInsets.symmetric(horizontal: 140.0),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: answer.length,
            itemBuilder: (context, index) {
              var _answer = answer[index];
              values.add(false);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  index == 0
                      ? CustomAnswerFormField(
                          keyboardType: TextInputType.text,
                          textcontroller: controller,
                          errorMessage: "Vergeten in te vullen",
                          validator: 1, //checking if its a number
                          answerModel: _answer,
                          function: null,
                        )
                      : Container(),
                  _answer.type == "AnswerType.closed"
                      ? RadioListTile(
                          value: answer[index].option,
                          groupValue: selectedAnswer,
                          activeColor: ColorTheme.accentOrange,
                          title: Text(
                            answer[index].option,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onChanged: (value) {
                            setState(() {
                              controller.text = answer[index].option;
                              selectedAnswer = value;
                              setNextQuestion(answer[index].next);
                            });
                          },
                          selected: selectedAnswer == answer[index].option,
                        )
                      : CheckBoxSurvey(
                          answer: _answer,
                          selected: values[index],
                          controller: controller,
                          function: setNextQuestion,
                        )
                ],
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, size.height),
            painter: TopLargeWavePainter(
              color: ColorTheme.extraLightOrange,
            ),
          ),
          Align(
            alignment: nextQuestionInQue == 8 || nextQuestionInQue == 0
                ? Alignment.center
                : Alignment.topCenter,
            child: Container(
              width: size.width > 1300 ? size.width / 1.5 : size.width,
              child: SingleChildScrollView(
                child: nextQuestionInQue != 0 && nextQuestionInQue != 8
                    ? Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            fetchQuestion(context),
                            size.width < 900
                                ? Container()
                                : SizedBox(
                                    height: 100,
                                  ),
                          ],
                        ),
                      )
                    : DownloadApp(
                        number: nextQuestionInQue,
                      ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: size.width < 900 ? size.height * 0.15 : 145,
        padding: EdgeInsets.symmetric(horizontal: size.width < 900 ? 0 : 200),
        child: nextQuestionInQue != 0 && nextQuestionInQue != 8
            ? TutorialButtons(
                canGoBack: true,
                onPressedBack: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LandingPageApp(),
                  ),
                ),
                onPressedNext: () => nextQuestion(),
              )
            : Center(
                child: SizedBox(
                  width: 400,
                  child: ConfirmOrangeButton(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => LandingPageApp(),
                      ),
                    ),
                    text: "Bedankt voor uw deelname",
                  ),
                ),
              ),
      ),
    );
  }
}
