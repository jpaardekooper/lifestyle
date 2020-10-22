import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/widgets/datepicker/datepicker.dart';
import 'package:lifestylescreening/widgets/text/welcome_text.dart';

class DiaryTab extends StatefulWidget {
  @override
  _DiaryTabState createState() => _DiaryTabState();
}

class _DiaryTabState extends State<DiaryTab> {
  String _myName;
  // String _myEmail;
  bool value = false;

  @override
  void initState() {
    super.initState();
    getMyInfoAndQuiz();
  }

  getMyInfoAndQuiz() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _myName = value;
      });
    });

    // await HelperFunctions.getUserEmailSharedPreference().then((value) {
    //   setState(() {
    //     _myEmail = value;
    //   });
    // });
    //print("Filling up some dat $_myName");
    //  print("Filling up some dat $_myEmail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 30, right: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DatePickerTimeLine(),
              WelcomeText(name: _myName),
              // Container(
              //     child: CupertinoDatePicker(
              //   mode: CupertinoDatePickerMode.date,
              //   initialDateTime: DateTime.now(),
              //   onDateTimeChanged: (dateTime) {
              //     debugPrint("$dateTime");
              //   },
              // ))
            ],
          ),
        ),
      ),
    );
  }
}
