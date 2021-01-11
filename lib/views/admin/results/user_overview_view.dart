import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/result_controller.dart';
import 'package:lifestylescreening/models/dtd_screening_model.dart';
import 'package:lifestylescreening/models/result_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'package:lifestylescreening/views/admin/results/dtd_results_view.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

import '../../../healthpoint_icons.dart';

class UserResultsOverview extends StatefulWidget {
  UserResultsOverview({@required this.resultInfo});
  final ResultModel resultInfo;

  @override
  _UserResultsOverviewState createState() => _UserResultsOverviewState();
}

class _UserResultsOverviewState extends State<UserResultsOverview> {
  final ResultController _resultController = ResultController();

  StreamSubscription<QuerySnapshot> _currentSubscription;
  bool _isLoading = true;
  List<DtdModel> _dtdResults = <DtdModel>[];
  List<SurveyResultModel> _surveyResults = <SurveyResultModel>[];

  @override
  void initState() {
    super.initState();
    _currentSubscription = _resultController
        .streamResultUsers(widget.resultInfo.id)
        .listen(_updateResultList);
  }

  @override
  void dispose() {
    super.dispose();
    _currentSubscription?.cancel();
    _dtdResults.clear();
    _surveyResults.clear();
  }

  void _updateResultList(QuerySnapshot snapshot) {
    if (widget.resultInfo.title == "DTD - screening") {
      setState(() {
        _isLoading = false;
        _dtdResults = _resultController.getDtdUserList(snapshot);
      });
    } else if (widget.resultInfo.title == "Screening test") {
      setState(() {
        _isLoading = false;
        _surveyResults = _resultController.getSurveyUserList(snapshot);
      });
    }
  }

  Widget showDTDResults() {
    return ListView.builder(
      itemCount: _dtdResults.length,
      itemBuilder: (BuildContext ctxt, int index) {
        DtdModel result = _dtdResults[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ListTile(
                    tileColor: ColorTheme.extraLightOrange,
                    title: H2Text(text: result.fieldId),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DtdResultView(
                          result: result,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget showSurveyResults() {
    return ListView.builder(
      itemCount: _surveyResults.length,
      itemBuilder: (BuildContext ctxt, int index) {
        SurveyResultModel result = _surveyResults[index];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: ListTile(
                    tileColor: ColorTheme.extraLightOrange,
                    title: H2Text(text: result.email),
                    onTap: null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : widget.resultInfo.title == "DTD - screening"
              ? showDTDResults()
              : showSurveyResults(),
    );
  }
}
