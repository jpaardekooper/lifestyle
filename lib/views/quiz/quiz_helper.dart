import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/services/database.dart';
import 'package:lifestylescreening/views/quiz/createquiz.dart';
import 'package:lifestylescreening/views/quiz/editquestions.dart';
import 'package:lifestylescreening/views/quiz/quiz.dart';

String selectedMenuItem = "Home";

String _myName = "";
String _myEmail = "";

class QuizHelper extends StatefulWidget {
  @override
  _QuizHelperState createState() => _QuizHelperState();
}

DatabaseService _databaseService = DatabaseService();

class _QuizHelperState extends State<QuizHelper> {
  Stream quizStream;

  @override
  void initState() {
    getMyInfoAndQuiz();
    super.initState();
  }

  Widget quizList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: StreamBuilder(
        stream: quizStream,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : snapshot.data.docs.length == 0
                  ? Container(
                      width: 250,
                      child: Text(
                        "No quiz found, click on the (+) button to create quiz",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 50),
                      itemCount: snapshot.data.docs.length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        // return Text(snapshot.data.docs[index]
                        //     .data()["quizTitle"]
                        //     .toString());
                        return QuizTile(
                          imgUrl: snapshot.data.docs[index]
                                  .data()["quizImgurl"] ??
                              "https://www.ippocrateas.eu/wp-content/uploads/2019/08/ippocrate-e-health-m-health-eng_sito-1400x760.jpg",
                          desc: snapshot.data.docs[index].data()["quizDesc"],
                          title: snapshot.data.docs[index].data()["quizTitle"],
                          quizid: snapshot.data.docs[index].data()["quizId"],
                        );
                      });
        },
      ),
    );
  }

  getMyInfoAndQuiz() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    _myEmail = await HelperFunctions.getUserEmailSharedPreference();
    // print("Filling up some dat $_myName");
    _databaseService.getQuizezData(_myName).then((val) {
      setState(() {
        quizStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      padding: EdgeInsets.only(top: 24),
      alignment: Alignment.center,
      child: quizList(),
    );
  }
}

void _moreOptionBottomSheet(
    {@required context,
    @required String quizId,
    @required String title,
    @required String desc,
    @required String quizImageUrl}) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.only(bottom: 36),
          child: Wrap(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Text(
                    "More Options..",
                    style: TextStyle(fontSize: 16),
                  )),
              ListTile(
                  leading: Icon(Icons.delete),
                  title: Text(
                    'Delete Blog',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    _databaseService.removeQuiz(quizId, _myName);
                    Navigator.pop(context);
                  }),
              ListTile(
                leading: Icon(Icons.share),
                title: Text(
                  'Share',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () => {},
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text(
                  'Edit Quiz Info',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateQuiz(
                                isNew: false,
                                title: title,
                                desc: desc,
                                quizId: quizId,
                                quizImageUrl: quizImageUrl,
                              )));
                },
              ),
              ListTile(
                leading: Icon(Icons.question_answer),
                title: Text(
                  'Edit Questions',
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditQuestions(
                                quizId: quizId,
                                myAwesomeName: _myName,
                              )));
                },
              ),
            ],
          ),
        );
      });
}

class QuizTile extends StatelessWidget {
  QuizTile(
      {@required this.imgUrl,
      @required this.title,
      @required this.desc,
      @required this.quizid});

  final String imgUrl;
  final String title;
  final String desc;
  final String quizid;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(bottom: 12, right: 13),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                child: CachedNetworkImage(
                  placeholder: (context, url) => Container(
                      width: MediaQuery.of(context).size.width - 48,
                      child: Center(child: CircularProgressIndicator())),
                  imageUrl: imgUrl,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width - 48,
                  height: 150,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        topLeft: Radius.circular(8))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(desc ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              _myEmail != "email@example.com"
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width - 48,
                      height: 150,
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          _moreOptionBottomSheet(
                              context: context,
                              title: title,
                              desc: desc,
                              quizImageUrl: imgUrl,
                              quizId: quizid);
                        },
                        child: Container(
                            padding: EdgeInsets.all(4),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                            ),
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 20,
                            )),
                      ),
                    ),
            ],
          ),
          GestureDetector(
            onTap: () {
              //print("Monitor");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Monitor(quizid, _myName)));
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Text(
                      "Play Now",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}