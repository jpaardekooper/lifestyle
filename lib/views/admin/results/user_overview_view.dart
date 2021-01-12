import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/result_controller.dart';
import 'package:lifestylescreening/models/dtd_screening_model.dart';
import 'package:lifestylescreening/models/result_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'package:lifestylescreening/views/admin/results/dtd_results_view.dart';
import 'package:lifestylescreening/views/admin/results/survey_category_overview.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h1_text.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';
import 'package:intl/intl.dart';
import 'package:lifestylescreening/widgets/text/lifestyle_text.dart';

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
  List<DtdModel> _dtdResults = [];
  List<SurveyResultModel> _surveyResults = [];

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
    _dtdResults.sort((a, b) => a.date.compareTo(b.date));
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
                    title: H2Text(
                      text: DateFormat("yyy-MM-dd HH:mm")
                          .format(result.date.toDate()),
                    ),
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
    return _isLoading
        ? CircularProgressIndicator()
        : GridView.builder(
            shrinkWrap: true,
            itemCount: _surveyResults.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 3 : 2,
              //  childAspectRatio: (itemWidth / itemHeight),
            ),
            itemBuilder: (BuildContext ctxt, int index) {
              SurveyResultModel _result = _surveyResults[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: ColorTheme.extraLightOrange,
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => SurveyCategoryOverview(
                                result: _result,
                              )),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          H2Text(
                            text: DateFormat('yyy-MM-dd').format(
                              _result.date.toDate(),
                            ),
                          ),
                          LifestyleText(
                            text: _result.email,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _result.categories.length,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Text("${_result.categories[index]}"),
                                  ),
                                  Text(_result.points_per_category[index]
                                      .toString())
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          LifestyleText(text: "Totaal aantal punten:"),
                          SizedBox(height: 5),
                          LifestyleText(text: _result.total_points.toString())
                        ],
                      ),
                    ),
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
