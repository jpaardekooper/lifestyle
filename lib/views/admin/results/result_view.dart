import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lifestylescreening/controllers/result_controller.dart';
import 'package:lifestylescreening/models/result_model.dart';
import 'package:lifestylescreening/views/admin/results/user_overview_view.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

class ResultView extends StatefulWidget {
  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final ResultController _resultController = ResultController();

  StreamSubscription<QuerySnapshot> _currentSubscription;
  bool _isLoading = true;
  List<ResultModel> _results = <ResultModel>[];

  @override
  void initState() {
    super.initState();
    _currentSubscription =
        _resultController.streamResults().listen(_updateResultList);
  }

  @override
  void dispose() {
    super.dispose();
    _currentSubscription?.cancel();
    _results.clear();
  }

  void _updateResultList(QuerySnapshot snapshot) {
    setState(() {
      _isLoading = false;
      _results = _resultController.getResultList(snapshot);
    });
  }

  Widget showResults(BuildContext context) {
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (BuildContext ctxt, int index) {
        ResultModel result = _results[index];

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
                    title: H2Text(text: result.title),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserResultsOverview(
                          resultInfo: result,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 1280),
          child: _isLoading
              ? CircularProgressIndicator()
              : _results.isNotEmpty
                  ? showResults(context)
                  : Center(
                      child: Text('Geen Results gevonden'),
                      //onPressed: _onAddRandomRecipesPressed,
                    ),
        ),
      ),
    );
  }
}
