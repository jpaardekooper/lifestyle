import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/helper/theme.dart';
import 'package:lifestylescreening/views/createquiz.dart';
import 'package:lifestylescreening/views/home.dart';
import 'package:lifestylescreening/widgets/widgets.dart';

class HomeContainer extends StatefulWidget {
  @override
  _HomeContainerState createState() => _HomeContainerState();
}

/// Global Variables

String _myName = "";

/// Stream
Stream infoStream;

class _HomeContainerState extends State<HomeContainer> {
  String _myEmail = "";

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
                appBar: AppBar(title: Text('welkom $_myName')),
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
