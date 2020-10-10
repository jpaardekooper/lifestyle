import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/helper/functions.dart';

class DiaryTab extends StatefulWidget {
  @override
  _DiaryTabState createState() => _DiaryTabState();
}

class _DiaryTabState extends State<DiaryTab> {
  String _myName = "";
  String _myEmail = "";
  @override
  void initState() {
    super.initState();
    getMyInfoAndQuiz();
  }

  getMyInfoAndQuiz() async {
    _myName = await HelperFunctions.getUserNameSharedPreference();
    _myEmail = await HelperFunctions.getUserEmailSharedPreference();
    print("Filling up some dat $_myName");
    print("Filling up some dat $_myEmail");
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
            Container(
              height: 250,
              color: Colors.red[600],
              child: const Center(child: Text('Entry A')),
            ),
            Container(
              height: 250,
              color: Colors.red[500],
              child: const Center(child: Text('Entry B')),
            ),
            Container(
              height: 250,
              color: Colors.yellow[100],
              child: const Center(child: Text('Entry C')),
            ),
          ],
        ),
      ),
    );
  }
}
