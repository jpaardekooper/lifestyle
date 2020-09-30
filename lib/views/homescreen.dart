import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/helper/theme.dart';
import 'package:lifestylescreening/services/auth.dart';
import 'package:lifestylescreening/views/createquiz.dart';
import 'package:lifestylescreening/views/home.dart';
import 'package:lifestylescreening/views/signin.dart';
import 'package:lifestylescreening/widgets/widgets.dart';

class HomeContainer extends StatefulWidget {
  @override
  _HomeContainerState createState() => _HomeContainerState();
}

AuthService auth;

/// Global Variables

String _myName = "";
String _myEmail = "";

/// Stream
Stream infoStream;

class _HomeContainerState extends State<HomeContainer> {
  getMyInfoAndQuiz() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    _myEmail = await HelperFunctions.getUserEmailSharedPreference();
    print("Filling up some dat $_myName");
    print("Filling up some dat $_myEmail");
  }

  @override
  void initState() {
    getMyInfoAndQuiz();

    if (infoStream == null) {
      infoStream = Stream<String>.periodic(Duration(milliseconds: 100), (x) {
        return selectedMenuItem;
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    infoStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
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
                            print("halo");

                            // await auth.signOut();
                            await HelperFunctions
                                .saveUserLoggedInSharedPreference(false);

                            await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          child: Icon(
                            Icons.offline_bolt_rounded,
                            size: 26.0,
                          ),
                        )),
                  ],
                ),
                body: Home(),
                floatingActionButton: FloatingActionButton(
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
            : Container(
                child: Center(
                child: Text("no data has been found"),
              ));
      },
    ));
  }
}
