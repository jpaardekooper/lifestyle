import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
import 'package:lifestylescreening/models/answer_model.dart';
import 'package:lifestylescreening/models/category_model.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/widgets/dialog/edit_answer_dialog.dart';
import 'package:lifestylescreening/widgets/text/body_text.dart';

class AdminAnswerCard extends StatelessWidget {
  AdminAnswerCard(
      {Key key, @required this.category, @required this.questionModel})
      : super(key: key);
  final CategoryModel category;
  final QuestionModel questionModel;

  final QuestionnaireController _questionnaireController =
      QuestionnaireController();

  static const String open = "AnswerType.open";
  static const String closed = "AnswerType.closed";
  static const String multipleChoice = "AnswerType.multipleChoice";

  void _editAnswer(
      QuestionModel question, AnswerModel answer, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return EditAnswerDialog(
          surveyId: category.id,
          answer: answer,
          question: question,
          insertNewAnswer: false,
          totalQuestion: 0,
        );
      },
    );
  }

  void _deleteAnswer(AnswerModel answer, QuestionModel question) {
    _questionnaireController.removeAnswerFromQuestion(
        category.id, question.id, answer.id);
  }

  Widget answerTypeIcon(AnswerModel answer) {
    switch (answer.type) {
      case open:
        return Text("open");
        break;
      case closed:
        return Text("gesloten");
        break;
      case multipleChoice:
        return Text("meerkeuze");
        break;
      default:
        return Text("");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: StreamBuilder<QuerySnapshot>(
        stream: _questionnaireController.streamAnswers(
          category.id,
          questionModel.id,
        ),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<AnswerModel> _answerList = [];
          if (!snapshot.hasData) {
            return Container();
          } else {
            _answerList = _questionnaireController.fetchAnswers(snapshot);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 30,
                      child: BodyText(
                        text: "Nr:",
                      ),
                    ),
                    Expanded(flex: 2, child: BodyText(text: "Type:")),
                    Expanded(flex: 2, child: BodyText(text: "Antwoord:")),
                    Expanded(flex: 2, child: BodyText(text: "Volgende vraag:")),
                    //   SizedBox(width: 5),
                    Expanded(child: BodyText(text: "Score:")),
                    Expanded(child: Container()),
                  ],
                ),
                Divider(),
                ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _answerList.length,
                  itemBuilder: (context, index) {
                    AnswerModel answer = _answerList[index];

                    if (_answerList.isEmpty) {
                      return Text("Er zijn geen vragen gevonden");
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 30, child: Text(answer.order.toString())),
                          Expanded(flex: 2, child: answerTypeIcon(answer)),
                          Expanded(
                              flex: 2, child: Text("... ${answer.option}")),
                          //   SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "${answer.next.toString()}",
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          Expanded(child: Text(answer.points.toString())),
                          Expanded(
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => _editAnswer(
                                      questionModel, answer, context),
                                  child: Icon(
                                    Icons.edit,
                                    size: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () =>
                                      _deleteAnswer(answer, questionModel),
                                  child: Icon(
                                    Icons.remove_circle,
                                    size: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
