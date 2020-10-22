import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/views/quiz/addquestion.dart';

class EditQuestions extends StatefulWidget {
  EditQuestions({@required this.quizId, @required this.myAwesomeName});
  final String quizId, myAwesomeName;
  @override
  _EditQuestionsState createState() => _EditQuestionsState();
}

class _EditQuestionsState extends State<EditQuestions> {
  QuerySnapshot questionsSnapshot;
  DatabaseService databaseService = DatabaseService();

  Widget questionList() {
    return Container(
      child: questionsSnapshot != null
          ? ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: questionsSnapshot.docs.length,
              itemBuilder: (context, index) {
                return QuestionListTile(
                  questionModel: getQuestionModelFromDatasnapshot(
                      questionsSnapshot.docs[index]),
                  number: "${index + 1}",
                  quizId: widget.quizId,
                );
              })
          : Container(
              height: MediaQuery.of(context).size.height - 150,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }

  @override
  void initState() {
    //print("${widget.quizId}, this is name ${widget.myAwesomeName}");

    FirebaseFirestore.instance
        .collection("Quiz")
        .doc(widget.myAwesomeName)
        .collection("MyQuiz")
        .doc(widget.quizId)
        .collection("QNA")
        .get()
        .then((value) {
      questionsSnapshot = value;
      //  print("this is length ${questionsSnapshot.docs.length}");
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("edit question"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
              child: Text("Click on the question to edit",
                  style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: 8,
            ),
            questionList()
          ],
        ),
      ),
    );
  }
}

QuestionModel getQuestionModelFromDatasnapshot(
    DocumentSnapshot questionSnapshot) {
  QuestionModel questionModel = QuestionModel();

  questionModel.question = questionSnapshot.data()["question"];

  questionModel.option1 = questionSnapshot.data()["option1"];
  questionModel.option2 = questionSnapshot.data()["option2"];
  questionModel.option3 = questionSnapshot.data()["option3"];

  questionModel.correctOption = questionSnapshot.data()["option1"];
  questionModel.answered = false;

  return questionModel;
}

class QuestionListTile extends StatelessWidget {
  QuestionListTile(
      {@required this.questionModel,
      @required this.number,
      @required this.quizId});
  final QuestionModel questionModel;
  final String number;
  final String quizId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddQuestion(
                      isNew: false,
                      quizId: quizId,
                      questionModel: questionModel,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
        child: Row(
          children: <Widget>[
            Text(
              "Q$number ${questionModel.question}",
              style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w400),
            ),
            Spacer(),
            Icon(Icons.navigate_next)
          ],
        ),
      ),
    );
  }
}
