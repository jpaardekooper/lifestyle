import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';
import 'package:lifestylescreening/widgets/datepicker/datepicker.dart';

class DiaryTab extends StatefulWidget {
  @override
  _DiaryTabState createState() => _DiaryTabState();
}

class _DiaryTabState extends State<DiaryTab> {
  String _myName = "";
  // String _myEmail = "";
  bool value = false;

  @override
  void initState() {
    super.initState();
    getMyInfoAndQuiz();
  }

  getMyInfoAndQuiz() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    //   _myEmail = await HelperFunctions.getUserEmailSharedPreference();
    //print("Filling up some dat $_myName");
    //  print("Filling up some dat $_myEmail");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("a"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DatePickerTimeLine(),
            Text("WELKOM $_myName"),
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
    );
  }
}
