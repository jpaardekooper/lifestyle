// import 'package:flutter/material.dart';
// import 'package:lifestylescreening/controllers/questionnaire_controller.dart';
// import 'package:lifestylescreening/models/answer_model.dart';
// import 'package:lifestylescreening/models/question_model.dart';
// import 'package:lifestylescreening/models/questionnaire_model.dart';
// import 'package:lifestylescreening/widgets/cards/screening_selected_answer.dart';

// // ignore: must_be_immutable
// class ScreeningQnaView extends StatelessWidget {
//   ScreeningQnaView({
//     Key key,
//     @required this.addAnswer,
//     @required this.addController,
//     @required this.value,
//     @required this.category,
//     @required this.id,
//   }) : super(key: key);

//   final VoidCallback addController;

//   final double value;

//   final String category;

//   final String id;

//   final Function(int, QuestionnaireModel) addAnswer;

//   final QuestionnaireController _questionnaireController =
//       QuestionnaireController();

//   List<QuestionModel> _questionList = [];

//   List<TextEditingController> textControllerList = [];

//   Widget showAnsers(QuestionModel question, int i) {
//     return FutureBuilder<List<AnswerModel>>(
//       //fetching data from the corresponding questionId
//       future: _questionnaireController.fetchAnswer(question.id),
//       builder: (context, snapshot) {
//         List<AnswerModel> _answerList = snapshot.data;
//         if (_answerList == null || _answerList.isEmpty) {
//           return Container();
//         } else {
//           return ScreeningSelectedAnswer(
//             //    question: question.question,
//             addAnswer: addAnswer,
//             answerList: _answerList,
//             textController: textControllerList[i],
//             i: i,
//           );
//         }
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         LinearProgressIndicator(
//           value: value,
//           backgroundColor: Colors.white,
//           valueColor:
//               AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
//           minHeight: 5,
//         ),
//         FutureBuilder<List<QuestionModel>>(
//           future: _questionnaireController.fetchScreeningQuestion(id, category),
//           builder: (context, snapshot) {
//             _questionList = snapshot.data;

//             if (_questionList == null || _questionList.isEmpty) {
//               return Center(child: CircularProgressIndicator());
//             } else {
//               //get the correct question from the list
//               //       _questionList.sort((a, b) => a.order.compareTo(b.order));

//               return ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: _questionList.length,
//                 itemBuilder: (BuildContext context, index) {
//                   var question = _questionList[index];
//                   addController();
//                   textControllerList.add(TextEditingController());

//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Text(
//                           "${question.order}. ${question.question}",
//                           style: TextStyle(
//                               fontSize:
//                                   MediaQuery.of(context).size.height * 0.03),
//                         ),
//                         showAnsers(
//                           question,
//                           index,
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }
