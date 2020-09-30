import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/question_model.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/views/result.dart';
import 'package:lifestylescreening/widgets/optiontile.dart';

class Monitor extends StatefulWidget {
  Monitor(this.quizId, this.myName);
  final String quizId;
  final String myName;

  @override
  _MonitorState createState() => _MonitorState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

QuerySnapshot questionsSnapshot;

/// Stream
Stream infoStream;
List<QuestionModel> questionsList = List<QuestionModel>();

class _MonitorState extends State<Monitor> {
  DatabaseService databaseService = DatabaseService();

  bool isList;

  @override
  void initState() {
    /// Stream
    if (infoStream == null) {
      infoStream = Stream<List<QuestionModel>>.periodic(
          Duration(milliseconds: 100), (x) {
        return questionsList;
      });
    }

    isList = true;
    print("${widget.quizId}");
    databaseService.getQuizData(widget.quizId, widget.myName).then((value) {
      questionsSnapshot = value;
      questionsList = getListFromDatasnapshot(questionsSnapshot);
      _notAttempted = questionsList.length;
      _correct = 0;
      _incorrect = 0;
      total = questionsSnapshot.docs.length;

      print("$total this is total");
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    questionsList = List<QuestionModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      drawer: QuizInfoMenu(
        isList: isList,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              questionsSnapshot == null
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      color: Colors.white,
                      child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: questionsSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            return QuizPlayTile(
                              questionModel: getQuestionModelFromList(
                                  questionsList[index]),
                              index: index,
                            );
                          }),
                    )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Results(
                correct: _correct,
                incorrect: _incorrect,
                total: total,
                questionsAndAnswers: questionsList,
              ),
            ),
          );
        },
      ),
    );
  }
}

List<QuestionModel> getListFromDatasnapshot(QuerySnapshot questionSnapshot) {
  List<QuestionModel> questionsList = List();
  QuestionModel questionModel = QuestionModel();
  for (int i = 0; i < questionSnapshot.docs.length; i++) {
    questionModel.question = questionSnapshot.docs[i].data()["question"];
    questionModel.option1 = questionSnapshot.docs[i].data()["option1"];
    questionModel.option2 = questionSnapshot.docs[i].data()["option2"];
    questionModel.option3 = questionSnapshot.docs[i].data()["option3"];
    questionModel.answered = false;
    questionModel.correctOption = questionModel.option1;
    questionModel.isMarkedForReview = false;
    questionModel.userResponse = "";
    questionsList.add(questionModel);

    questionModel = QuestionModel();
  }
  return questionsList;
}

QuestionModel getQuestionModelFromList(QuestionModel questionModel) {
  QuestionModel newquestionModel = QuestionModel();

  newquestionModel.question = questionModel.question;

  List<String> options = [
    questionModel.option1,
    questionModel.option2,
    questionModel.option3,
  ];

  // maybe later
//  options.shuffle();

  newquestionModel.option1 = options[0];
  newquestionModel.option2 = options[1];
  newquestionModel.option3 = options[2];

  newquestionModel.correctOption = questionModel.option1;
  newquestionModel.answered = false;
  newquestionModel.isMarkedForReview = false;
  questionModel.userResponse = "";

  return newquestionModel;
}

class QuizPlayTile extends StatefulWidget {
  QuizPlayTile({this.questionModel, this.index});
  final QuestionModel questionModel;
  final int index;

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.8,
            child: new Column(
              children: <Widget>[
                ListTile(
                  subtitle: Text(
                    "Q${widget.index + 1} ${widget.questionModel.question ?? "Not Found"}",
                    style: TextStyle(fontSize: 17, color: Colors.black87),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        questionsList[widget.index].isMarkedForReview =
                            !questionsList[widget.index].isMarkedForReview;
                      });
                    },
                    child: Opacity(
                        opacity: 0.7,
                        child: questionsList[widget.index].isMarkedForReview
                            ? Icon(
                                Icons.star,
                                color: Colors.yellow,
                              )
                            : Icon(
                                Icons.star,
                                color: Colors.grey,
                              )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              //       if (!widget.questionModel.answered) {
              ///correct
              if (widget.questionModel.option1 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option1;

                questionsList[widget.index].userResponse =
                    widget.questionModel.option1;

                widget.questionModel.answered = true;

                questionsList[widget.index].answered = true;
                print("done");

                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              } else {
                optionSelected = widget.questionModel.option1;

                questionsList[widget.index].userResponse =
                    widget.questionModel.option1;

                widget.questionModel.answered = true;

                questionsList[widget.index].answered = true;
                print("done");

                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
              //        }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option1,
              option: "A",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              //        if (!widget.questionModel.answered) {
              ///correct
              if (widget.questionModel.option2 ==
                  widget.questionModel.correctOption) {
                optionSelected = widget.questionModel.option2;

                questionsList[widget.index].userResponse =
                    widget.questionModel.option2;

                widget.questionModel.answered = true;

                questionsList[widget.index].answered = true;
                print("done");

                _correct = _correct + 1;
                _notAttempted = _notAttempted - 1;
                print("${widget.questionModel.correctOption}");
                setState(() {});
              } else {
                optionSelected = widget.questionModel.option2;

                questionsList[widget.index].userResponse =
                    widget.questionModel.option2;

                widget.questionModel.answered = true;

                questionsList[widget.index].answered = true;
                print("done");

                _incorrect = _incorrect + 1;
                _notAttempted = _notAttempted - 1;
                setState(() {});
              }
              //       }
            },
            child: OptionTile(
              correctAnswer: widget.questionModel.correctOption,
              description: widget.questionModel.option2,
              option: "B",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          widget.questionModel.question != null
              ? Container()
              : GestureDetector(
                  onTap: () {
                    //   if (!widget.questionModel.answered) {
                    ///correct
                    if (widget.questionModel.option3 ==
                        widget.questionModel.correctOption) {
                      optionSelected = widget.questionModel.option3;

                      questionsList[widget.index].userResponse =
                          widget.questionModel.option3;

                      widget.questionModel.answered = true;

                      questionsList[widget.index].answered = true;
                      print("done");

                      _correct = _correct + 1;
                      _notAttempted = _notAttempted - 1;
                      setState(() {});
                    } else {
                      optionSelected = widget.questionModel.option3;

                      questionsList[widget.index].userResponse =
                          widget.questionModel.option3;

                      widget.questionModel.answered = true;

                      questionsList[widget.index].answered = true;
                      print("done");

                      _incorrect = _incorrect + 1;
                      _notAttempted = _notAttempted - 1;
                      setState(() {});
                    }
                    //     }
                  },
                  child: OptionTile(
                    correctAnswer: widget.questionModel.correctOption,
                    description: widget.questionModel.option3,
                    option: "C",
                    optionSelected: optionSelected,
                  ),
                ),
          SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}

class NumberCircle extends StatelessWidget {
  NumberCircle(
      {@required this.number,
      @required this.color,
      @required this.isMarkedForReview});
  final String number;
  final Color color;
  final bool isMarkedForReview;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 35,
          width: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(40)),
          child: Text(number,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'OverpassRegular',
                  fontWeight: FontWeight.w500)),
        ),
        isMarkedForReview
            ? Container(
                height: 35,
                width: 35,
                alignment: Alignment.topRight,
                child: Icon(Icons.star),
              )
            : Container()
      ],
    );
  }
}

Widget questionNumberGrid() {
  return GridView(
    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
    shrinkWrap: true,
    physics: ClampingScrollPhysics(),
    scrollDirection: Axis.vertical,
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisSpacing: 0.0, maxCrossAxisExtent: 50.0),
    children: List.generate(questionsSnapshot.docs.length, (index) {
      return NumberCircle(
        isMarkedForReview: questionsList[index].isMarkedForReview,
        number: "${index + 1}",
        color: questionsList[index].answered ? Colors.green : Colors.red,
      );
    }),
  );
}

Widget questionList() {
  return Container(
    child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: questionsSnapshot.docs.length,
        itemBuilder: (context, index) {
          return QuestionListTile(
            question: questionsList[index].question,
            number: "${index + 1}",
            isMarkedForReview: questionsList[index].answered,
            color: questionsList[index].answered ? Colors.green : Colors.red,
          );
        }),
  );
}

// ignore: must_be_immutable
class QuizInfoMenu extends StatefulWidget {
  QuizInfoMenu({@required this.isList});
  bool isList;

  @override
  _QuizInfoMenuState createState() => _QuizInfoMenuState();
}

///drawer
class _QuizInfoMenuState extends State<QuizInfoMenu> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Container(
                width: MediaQuery.of(context).size.width - 50,
                color: Color(0xff385F71),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              if (widget.isList) {
                                widget.isList = false;
                              }
                              setState(() {});
                            },
                            child: Opacity(
                              opacity: 0.7,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: widget.isList
                                          ? Colors.transparent
                                          : Colors.black54,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.grid_on)),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (!widget.isList) {
                                widget.isList = true;
                                setState(() {});
                              }
                            },
                            child: Opacity(
                              opacity: 0.7,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: widget.isList
                                          ? Colors.black54
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.list)),
                            ),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                        ],
                      ),
                    ),
                    questionsSnapshot == null
                        ? Container()
                        : widget.isList
                            ? questionList()
                            : questionNumberGrid(),
                    Spacer(),
                    Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text("Answered",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'OverpassRegular',
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text("Unanswered",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'OverpassRegular',
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Icon(Icons.star),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text("Marked For Review",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontFamily: 'OverpassRegular',
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              )
            : Container();
      },
    );
  }
}

class QuestionListTile extends StatelessWidget {
  QuestionListTile(
      {@required this.question,
      @required this.color,
      @required this.number,
      @required this.isMarkedForReview});
  final String question;
  final String number;
  final Color color;
  final bool isMarkedForReview;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
      child: Row(
        children: <Widget>[
          NumberCircle(
            isMarkedForReview:
                questionsList[int.parse(number) - 1].isMarkedForReview,
            number: number,
            color: color,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            question,
            style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
