import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/firebase_user.dart';

import 'package:lifestylescreening/models/question_model.dart';

import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'package:lifestylescreening/views/user/screening/screening_calc.dart';
import 'package:lifestylescreening/views/user/screening/survey_complete.dart';

import 'package:lifestylescreening/widgets/buttons/confirm_orange_button.dart';
import 'package:lifestylescreening/widgets/cards/selected_answer_card.dart';
import 'package:lifestylescreening/widgets/inherited/inherited_timer_service.dart';

import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class ScreeningView extends StatefulWidget {
  const ScreeningView({required this.user, required this.surveyTitle});
  final AppUser user;
  final String surveyTitle;
  @override
  _ScreeningViewState createState() => _ScreeningViewState();
}

class _ScreeningViewState extends State<ScreeningView> {
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  var _formKey;

  double? progressIndicatorValue;
  int? categoryIndex;
  int? screeningDuration;
  TimerService? timerService;
  late ScreeningCalc sc; //calculator for screening

  List<SurveyResultModel>? _surveyResult;
  List<SurveyModel>? _surveyList;
  late List<AnswerModel> _userAnswers;
  late List<String?> _questions;
  String? category;
  List<String> _questionAnswer = [];

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    timerService = TimerService();
    sc = ScreeningCalc();
    category = "";
    categoryIndex = 0;
    progressIndicatorValue = 0;
    timerService!.start();
    _surveyResult = [];
    _surveyList = [];
    _userAnswers = [];
    _questions = [];

    super.initState();
  }

  deleteControllers() async {
    timerService!.stop();
    _userAnswers.clear();
    _surveyResult!.clear();
    _surveyList!.clear();
    _questions.clear();
    category = "";
    categoryIndex = 0;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addAnswerToList(AnswerModel answer, String value) {
    if (!_userAnswers.contains(answer)) {
      _userAnswers.add(answer);
      _questionAnswer.add(value);
    }
  }

  nextQuestion(double progressValue) async {
    _userAnswers.clear();
    _questionAnswer.clear();

    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      screeningDuration = timerService!.currentDuration.inSeconds;

      List<int>? scorevalues = [];
      List<String>? categoriesList = [];
      //total score for a category
      int userCategoryScore = 0;
      int totalScorevalue = 0;
      int nextIndexQuestion = 0;
      userCategoryScore =
          await sc.calculatePoints(category, _userAnswers, _questionAnswer);

      int totalDurationValue = 0;

      Map<String, dynamic> data = {
        "question": FieldValue.arrayUnion(_questions),
        "answer": _questionAnswer,
        "points": userCategoryScore,
        "duration": screeningDuration,
        "date": DateTime.now()
      };

      if (_surveyList != null && _surveyList!.isNotEmpty) {
        categoriesList = _surveyList!.first.category;

        scorevalues.add(userCategoryScore);
      }
      if (_surveyResult != null && _surveyResult!.isNotEmpty) {
        categoriesList = _surveyResult!.first.categories;

        //first time doing survey
        if (category == "Bewegen") {
          totalScorevalue = userCategoryScore;
        } else {
          scorevalues = _surveyResult!.first.points_per_category;

          scorevalues!.add(userCategoryScore);
          //adding total score from fetch data + userCategory score
          totalScorevalue =
              _surveyResult!.first.total_points! + userCategoryScore;
          //adding duration from fetched data + screening duration
          totalDurationValue =
              _surveyResult!.first.total_duration! + screeningDuration!;
        }
      }

      if (categoryIndex! < categoriesList!.length) {
        nextIndexQuestion += categoryIndex! + 1;
      }

      Map<String, dynamic> surveyData = {
        "email": widget.user.email,
        "index": nextIndexQuestion,
        "categories": FieldValue.arrayUnion(categoriesList),
        "points_per_category": scorevalues,
        "total_points": totalScorevalue,
        "total_duration": totalDurationValue,
        "finished": false,
        "date": DateTime.now(),
      };

      await _questionnaireController.setUserSurveyAnswer(
          widget.surveyTitle,
          widget.user,
          category,
          categoryIndex,
          surveyData,
          data,
          category == "Bewegen" ? "" : _surveyResult!.first.id);

      await deleteControllers();

      final Route route = MaterialPageRoute(
        builder: (context) => ScreeningView(
          user: widget.user,
          surveyTitle: widget.surveyTitle,
        ),
      );
      await Navigator.pushReplacement(context, route);
    }
  }

  Widget showAnsers(String? category, QuestionModel question, int nr) {
    return FutureBuilder<List<AnswerModel>>(
      //fetching data from the corresponding questionId
      future: _questionnaireController.fetchAnswer(category, question.id),
      builder: (ctxt, snapshot) {
        List<AnswerModel>? _answerList = snapshot.data;
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
            //      controller: _controllerList[nr],
            function: addAnswerToList,
          );
        }
      },
    );
  }

//  List<int> controllersints = [];

  Widget getScreeningQuestion(String? category) {
    return FutureBuilder<List<QuestionModel>>(
      future: _questionnaireController.fetchScreeningQuestion(category),
      builder: (context, snapshot) {
        List<QuestionModel>? _questionList = snapshot.data;

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          //looping through questions list
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _questionList!.length,
            itemBuilder: (BuildContext ctx, index) {
              final QuestionModel question = _questionList[index];

              if (!_questions.contains(question)) {
                _questions.add(question.question);
              }

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
                    question.url!.contains("https://") && question.url != 0
                        ? CachedNetworkImage(
                            imageUrl: question.url!,
                            progressIndicatorBuilder:
                                (ctx, url, downloadProgress) =>
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
      },
    );
  }

  Widget showFirstTimeSurvey(double _progressValue, String? category) {
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
        //showing category
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: H1Text(text: "Vragen over $category"),
        ),
        //show questions
        getScreeningQuestion(category),
        // show next button
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
    return SurveyComplete(
      surveyResult: surveyResult,
      surveyTitle: widget.surveyTitle,
      user: widget.user,
    );
  }

  Widget getScreeningCategories() {
    return FutureBuilder<List<SurveyResultModel>>(
        //fetching data from the corresponding questionId
        future: _questionnaireController.checkSurveyResult(
                widget.surveyTitle, widget.user.email)
            as Future<List<SurveyResultModel>>?,
        builder: (context, snapshot) {
          _surveyResult = snapshot.data;
          //while loading
          //no data found or doesnt exist
          //doing quiz for the first time
          if (!snapshot.hasData || _surveyResult!.isEmpty) {
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
                  category = _surveyList!.first.category![categoryIndex!];
                  final _progressValue =
                      sc.calculateProgress(_surveyList!.first.category!.length);

                  progressIndicatorValue = _progressValue * categoryIndex;

                  if (categoryIndex == _surveyList!.first.category!.length) {
                    return surveyIsFinished(_surveyResult!.first);
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
                sc.calculateProgress(_surveyResult!.first.categories!.length);

            if (_surveyResult!.first.finished!) {
              categoryIndex = 0;
            } else {
              categoryIndex = _surveyResult!.first.index;
            }

            progressIndicatorValue = _progressValue * categoryIndex;

            if (categoryIndex == _surveyResult!.first.categories!.length &&
                _surveyResult!.first.finished == false) {
              return surveyIsFinished(_surveyResult!.first);
            } else {
              category = _surveyResult!.first.categories![categoryIndex!];
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TimerServiceProvider(
                service: timerService,
                child: getScreeningCategories(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
