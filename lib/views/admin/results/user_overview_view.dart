import 'package:flutter/material.dart';
import 'package:lifestylescreening/models/result_model.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';

import '../../../healthpoint_icons.dart';

class UserResultsOverview extends StatefulWidget {
  UserResultsOverview({@required this.resultInfo});
  final ResultModel resultInfo;

  @override
  _UserResultsOverviewState createState() => _UserResultsOverviewState();
}

class _UserResultsOverviewState extends State<UserResultsOverview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: H1Text(text: widget.resultInfo.title),
        backgroundColor: Colors.white,
        leading: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(HealthpointIcons.arrowLeftIcon),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(),
    );
  }
}
