import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/services/auth.dart';
import 'package:lifestylescreening/views/quiz/createquiz.dart';
import 'package:lifestylescreening/views/quiz/quiz_helper.dart';
import 'package:lifestylescreening/views/startup.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  AuthService auth;

  /// Global Variables

  String _myName = "";
  String _role = "";

  /// Stream
  Stream infoStream;
  getMyInfoAndQuiz() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    _role = await HelperFunctions.getUserRoleSharedPreference();
    // _myEmail = await HelperFunctions.getUserEmailSharedPreference();
    // print("Filling up some dat $_myName");
    // print("Filling up some dat $_myEmail");
  }

  @override
  void initState() {
    getMyInfoAndQuiz();

    infoStream ??= Stream<String>.periodic(Duration(milliseconds: 100), (x) {
      return selectedMenuItem;
    });

    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: infoStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Scaffold(
                appBar: AppBar(
                  title: Text('welkom $_myName'),
                  actions: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () async {
                            await auth.signOut();
                            await HelperFunctions
                                .saveUserLoggedInSharedPreference(false);

                            await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StartUp()));
                          },
                          child: Icon(
                            Icons.exit_to_app,
                            size: 26.0,
                          ),
                        )),
                  ],
                ),
                body: QuizHelper(),
                floatingActionButton: _role != "admin"
                    ? Container()
                    : FloatingActionButton(
                        child: Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateQuiz(
                                        isNew: true,
                                      )));
                        },
                      ))
            : Center(
                child: Text("no data has been found"),
              );
      },
    );
  }
}
