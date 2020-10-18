import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/widgets/logo/lifestyle_logo.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("DASHBOARD"),
      ),
      body: Container(
          color: Colors.blue,
          child: Card(
            child: Text("Welcome"),
          )),
    ));
  }
}
