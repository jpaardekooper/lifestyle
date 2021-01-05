import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/firebase_user.dart';

import 'package:lifestylescreening/models/question_model.dart';

import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';

import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/cards/selected_answer_card.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_timer_service.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class ScreeningView extends StatefulWidget {
  const ScreeningView({@required this.user, @required this.surveyTitle});
  final AppUser user;
  final String surveyTitle;
  @override
  _ScreeningViewState createState() => _ScreeningViewState();
}

class _ScreeningViewState extends State<ScreeningView> {
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  final _formKey = GlobalKey<FormState>();

  double progressIndicatorValue;
  int categoryIndex;
  int screeningDuration;
  final timerService = TimerService();
  List<TextEditingController> _controllerList;
  // List<QuestionModel> _questionList;
  List<SurveyResultModel> _surveyResult;
  List<SurveyModel> _surveyList;
  List<AnswerModel> _userAnswers;
  List<String> _questions;
  String category;
  // bool lastSurveyCategory;
  @override
  void initState() {
    category = "";
    categoryIndex = 0;
    progressIndicatorValue = 0;
    timerService.start();
    _controllerList = [];
//    _questionList = [];
    _surveyResult = [];
    _surveyList = [];
    _userAnswers = [];
    _questions = [];
    //   lastSurveyCategory = false;
    super.initState();
  }

  @override
  void dispose() {
    timerService.stop();

    timerService.dispose();
    super.dispose();
  }

  void addAnswerToList(AnswerModel answer) {
    if (!_userAnswers.contains(answer)) {
      _userAnswers.add(answer);
    } else {
      _userAnswers.remove(answer);
      _userAnswers.add(answer);
    }
  }

  nextQuestion(double progressValue) async {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      screeningDuration = timerService.currentDuration.inSeconds;
      List<String> _ansersToFirebaseList = [];
      List<String> categoriesList = [];
      //total score for a category
      int userCategoryScore = 0;

      // only for category bewegen
      int scorecalc = 0;
      for (int i = 0; i < _userAnswers.length; i++) {
        //different score calculation for category bewegen
        if (category == "Bewegen") {
          switch (_userAnswers[i].pointsCalculator) {
            case 0:
              userCategoryScore += _userAnswers[i].points;
              break;
            case 1:
              scorecalc +=
                  (double.parse(_controllerList[i].text) * 0.5).round();
              break;
            case 2:
              scorecalc += (double.parse(_controllerList[i].text) * 1).round();
              break;
            case 3:
              scorecalc += (double.parse(_controllerList[i].text) * 2).round();
              break;
            case 4:
              if (_userAnswers[i].lastAnswer == _controllerList[i].text)
                userCategoryScore += _userAnswers[i].points;
              break;
          }
        } else {
          switch (_userAnswers[i].pointsCalculator) {
            case 0:
              userCategoryScore += _userAnswers[i].points;
              break;
            case 1:
              userCategoryScore +=
                  (int.parse(_controllerList[i].text) * 0.5).round();
              break;
            case 2:
              userCategoryScore +=
                  (int.parse(_controllerList[i].text) * 1).round();
              break;
            case 3:
              userCategoryScore +=
                  (int.parse(_controllerList[i].text) * 2).round();
              break;
            case 4:
              if (_userAnswers[i].lastAnswer == _controllerList[i].text)
                userCategoryScore += _userAnswers[i].points;
              break;
          }
        }

        _ansersToFirebaseList.add(_controllerList[i].text);
      }

      if (scorecalc < 30) {
        userCategoryScore += 1;
      }

      Map<String, dynamic> data = {
        "question": FieldValue.arrayUnion(_questions),
        "answer": FieldValue.arrayUnion(_ansersToFirebaseList),
        "points": userCategoryScore,
        "duration": screeningDuration,
        "date": DateTime.now()
      };

      int totalScorevalue = 0;
      List<int> scorevalues = [];

      if (_surveyList.isNotEmpty) {
        categoriesList = _surveyList.first.category;

        scorevalues.add(userCategoryScore);
      }
      if (_surveyResult.isNotEmpty) {
        categoriesList = _surveyResult.first.categories;

        scorevalues = _surveyResult.first.points_per_category;
        scorevalues.add(userCategoryScore);

        totalScorevalue = _surveyResult.first.total_points;
        for (int i = 0;
            i < _surveyResult.first.points_per_category.length;
            i++) {
          totalScorevalue += _surveyResult.first.points_per_category[i];
        }
      }

      Map<String, dynamic> surveyData = {
        "email": widget.user.email,
        "index": categoryIndex + 1,
        "categories": FieldValue.arrayUnion(categoriesList),
        "category_points": FieldValue.arrayUnion(scorevalues),
        "total_points": totalScorevalue,
        "total_duration": screeningDuration,
        "finished": false,
        "date": DateTime.now(),
      };

      //user cat score

      await _questionnaireController.setUserSurveyAnswer(widget.surveyTitle,
          widget.user, category, categoryIndex, surveyData, data, false);

      timerService.reset();
      setState(() {
        //starting timer again
        timerService.start();
        _controllerList.clear();
        _userAnswers.clear();
        _ansersToFirebaseList.clear();
        _surveyResult.clear();
        _surveyList.clear();
        _questions.clear();
        category = "";
      });
    }
  }

  Widget showAnsers(String category, QuestionModel question, int index) {
    return FutureBuilder<List<AnswerModel>>(
      //fetching data from the corresponding questionId
      future: _questionnaireController.fetchAnswer(category, question.id),
      builder: (context, snapshot) {
        List<AnswerModel> _answerList = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done)
          return Center(
            child: Container(),
          );
        if (!snapshot.hasData) {
          return Center(
            child: Container(),
          );
        } else {
          return SelectedAnswerCard(
            answerList: _answerList,
            controller: _controllerList[index],
            function: addAnswerToList,
          );
        }
      },
    );
  }

  Widget getScreeningQuestion(String category) {
    return FutureBuilder<List<QuestionModel>>(
        future: _questionnaireController.fetchScreeningQuestion(category),
        builder: (context, snapshot) {
          final List<QuestionModel> _questionList = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //looping through questions list
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _questionList.length,
              itemBuilder: (BuildContext context, index) {
                final QuestionModel question = _questionList[index];
                _controllerList.add(TextEditingController());
                _questions.add(question.question);
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //show question number and question
                      Row(
                        children: [
                          Flexible(
                            child: H2Text(
                              text: "${question.order}.\t${question.question} ",
                            ),
                          ),
                        ],
                      ),
                      //check if question url exist and not equal to 0
                      question.url.contains("https://") && question.url != 0
                          ? CachedNetworkImage(
                              imageUrl: question.url,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : Container(),
                      //show answers for the question
                      //adding category question and index of iteration
                      showAnsers(category, question, index),
                    ],
                  ),
                );
              },
            );
          }
        });
  }

  Widget showFirstTimeSurvey(double _progressValue, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //progress value
        LinearProgressIndicator(
          value: progressIndicatorValue == 0
              ? _progressValue
              : progressIndicatorValue,
          backgroundColor: Colors.white,
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
          minHeight: 5,
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: H1Text(text: "Vragen over $category"),
        ),
        getScreeningQuestion(category),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConfirmOrangeButton(
            text: "Volgende",
            onTap: () {
              nextQuestion(_progressValue);
            },
          ),
        ),
      ],
    );
  }

  Widget surveyIsFinished(SurveyResultModel surveyResult) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Bedankt voor uw deelname"),
            ConfirmOrangeButton(
              text: "Terug",
              onTap: () {
                _questionnaireController.setSurveyToFalse(
                    widget.surveyTitle, widget.user, surveyResult);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getScreeningCategories() {
    return FutureBuilder<List<SurveyResultModel>>(
        //fetching data from the corresponding questionId
        future: _questionnaireController.checkSurveyResult(
            widget.surveyTitle, widget.user.email),
        builder: (context, snapshot) {
          _surveyResult = snapshot.data;
          //while loading
          if (snapshot.connectionState != ConnectionState.done)
            return Center(
              child: CircularProgressIndicator(),
            );
          //no data found or doesnt exist
          //doing quiz for the first time
          if (!snapshot.hasData || _surveyResult.isEmpty) {
            return FutureBuilder<List<SurveyModel>>(
              //fetching data from the corresponding questionId
              future:
                  _questionnaireController.fetchCategories(widget.surveyTitle),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  //if data has been found
                  _surveyList = snapshot.data;
                  category = _surveyList.first.category[categoryIndex];
                  final _progressValue =
                      1.0 / _surveyList.first.category.length.toDouble();

                  progressIndicatorValue = _progressValue * categoryIndex;

                  if (categoryIndex >= _surveyList.first.category.length - 1) {
                    return surveyIsFinished(_surveyResult.first);
                  }
                  //showing the actual survey data
                  else {
                    //widget if no data has been found or first quiz
                    return showFirstTimeSurvey(_progressValue, category);
                  }
                }
              },
            );
          } else {
            final _progressValue =
                1.0 / _surveyResult.first.categories.length.toDouble();

            categoryIndex = _surveyResult.first.index;

            if (_surveyResult.first.finished) {
              categoryIndex = 0;
            }

            progressIndicatorValue = _progressValue * categoryIndex;

            category = _surveyResult.first.categories[categoryIndex];

            if (categoryIndex >= _surveyResult.first.categories.length - 1 &&
                _surveyResult.first.finished == false) {
              return surveyIsFinished(_surveyResult.first);
            } else {
              return showFirstTimeSurvey(_progressValue, category);
            }
          }
        });
  }

  // Widget showTimerDuration() {
  //return TimerServiceProvider(
  //   service: timerService,
  //   child: AnimatedBuilder(
  //     animation: timerService, // listen to ChangeNotifier
  //     builder: (context, child) {
  //       return Text(
  //           'Elapsed: ${timerService.currentDuration.inSeconds}');
  //     },
  //   ),
  // ),
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HealthPoint Screening",
        ),
        centerTitle: true,
      ),
      body: TimerServiceProvider(
        service: timerService,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [getScreeningCategories()],
            ),
          ),
        ),
      ),
    );
  }
}
