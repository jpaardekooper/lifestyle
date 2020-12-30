import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/widgets/cards/admin_answer_card.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/dialog/edit_answer_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/edit_question_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/remove_question_dialog.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class QuestionView extends StatefulWidget {
  const QuestionView({@required this.categoryModel});
  final CategoryModel categoryModel;

  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  StreamSubscription<QuerySnapshot> _currentSubscription;

  bool _isLoading = true;
  List<QuestionModel> _questionList = [];

  int selectedIndex = 0;

  @override
  void initState() {
    _currentSubscription = _questionnaireController
        .streamQuestion(widget.categoryModel.id)
        .listen(_updateQNA);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _currentSubscription?.cancel();
  }

  void _updateQNA(QuerySnapshot snapshot) {
    setState(() {
      _questionList = _questionnaireController.fetchQuestions(snapshot);
      _isLoading = false;
    });
  }

  void _addQuestion(BuildContext contect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditQuestionDialog(
          category: widget.categoryModel,
          question: QuestionModel(),
          newQuestion: true,
          totalQuestion: _questionList.length + 1,
        );
      },
    );
  }

  void _editQuestion(QuestionModel question) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditQuestionDialog(
          category: widget.categoryModel,
          question: question,
          newQuestion: false,
          totalQuestion: 0,
        );
      },
    );
  }

  void _removeQuestion(QuestionModel question) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return RemoveQuestion(
          category: widget.categoryModel,
          question: question,
          totalQuestions: _questionList.length,
        );
      },
    );
  }

  Widget showEditButtons(QuestionModel question, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          tooltip: 'Vraag wijzigen',
          icon: Icon(
            Icons.edit,
          ),
          onPressed: () {
            _editQuestion(question);
          },
        ),
        IconButton(
          tooltip: 'Verwijder de vraag',
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _removeQuestion(question);
          },
        ),
        index == selectedIndex
            ? IconButton(
                tooltip: 'Voeg een antwoord toe',
                icon: Icon(Icons.add, color: Colors.blue),
                onPressed: () {
                  _addAnswer(question);
                },
              )
            : Container()
      ],
    );
  }

  Widget showHeaderInfo(QuestionModel question) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          H1Text(text: "Vraag: ${question.order}"),
          SizedBox(
            height: 10,
          ),
          question.url != "0"
              ? Row(
                  children: [
                    Text("Afbeelding: "),
                    Text(question.url),
                  ],
                )
              : Container(),
          SizedBox(
            height: 10,
          ),
          H2Text(text: question.question)
        ],
      ),
    );
  }

  void _addAnswer(QuestionModel question) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditAnswerDialog(
          surveyId: widget.categoryModel.id,
          answer: AnswerModel(),
          question: question,
          insertNewAnswer: true,
          totalQuestion: _questionList.length + 1,
        );
      },
    );
  }

  Widget showQuestionAndAnswer(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _questionList.length,
      itemBuilder: (BuildContext ctxt, int index) {
        QuestionModel question = _questionList[index];
        if (_questionList.isEmpty) {
          return Container();
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              color: selectedIndex == index
                  ? ColorTheme.extraLightOrange
                  : Colors.white,
              elevation: 8,
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    showEditButtons(question, index),
                    showHeaderInfo(question),
                    index == selectedIndex
                        ? AdminAnswerCard(
                            category: widget.categoryModel,
                            questionModel: question,
                          )
                        : Container(
                            height: 25,
                          )
                  ],
                ),
              ),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.categoryModel.category),
            Text(_questionList.length.toString())
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width < 1300
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width - 310,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _questionList.isNotEmpty
                ? showQuestionAndAnswer(context)
                : Center(
                    child: Text('Geen vragen gevonden'),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addQuestion(context),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
