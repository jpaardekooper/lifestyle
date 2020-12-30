import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lifestylescreening/controllers/survey_controller.dart';
import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/widgets/colors/color_theme.dart';
import 'package:lifestylescreening/widgets/dialog/edit_survey_dialog.dart';
import 'package:lifestylescreening/widgets/dialog/remove_survey_dialog.dart';
import 'package:lifestylescreening/widgets/text/h2_text.dart';

//Overzicht van alle surveys die gepubliceert zijn
class SurveyView extends StatefulWidget {
  @override
  _SurveyViewState createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {
  final SurveyController _surveyController = SurveyController();

  StreamSubscription<QuerySnapshot> _currentSubscription;
  bool _isLoading = true;
  List<SurveyModel> _surveys = <SurveyModel>[];

  @override
  void initState() {
    super.initState();
    _currentSubscription =
        _surveyController.streamSurveys().listen(_updateSurveyList);
  }

  @override
  void dispose() {
    super.dispose();
    _currentSubscription?.cancel();
    _surveys.clear();
  }

  void _updateSurveyList(QuerySnapshot snapshot) {
    setState(() {
      _isLoading = false;
      _surveys = _surveyController.getSurveyList(snapshot);
    });
  }

  void _editSurveyName(SurveyModel survey) {
    showDialog<EditSurveyView>(
        context: context,
        builder: (BuildContext context) {
          return EditSurveyView(
            surveyInfo: survey,
            newItem: false,
          );
        });
  }

  void _addSurvey(BuildContext context) {
    showDialog<EditSurveyView>(
      context: context,
      builder: (BuildContext context) {
        return EditSurveyView(
          surveyInfo: SurveyModel(),
          newItem: true,
        );
      },
    );
  }

  void _removeSurvey(SurveyModel survey) {
    showDialog<RemoveSurvey>(
      context: context,
      builder: (BuildContext context) {
        return RemoveSurvey(
          survey: survey,
        );
      },
    );
  }

  Widget showSurveys(BuildContext context) {
    return ListView.builder(
      itemCount: _surveys.length,
      itemBuilder: (BuildContext ctxt, int index) {
        SurveyModel survey = _surveys[index];

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
                    title: H2Text(text: survey.title),
                    subtitle: ListView.builder(
                      itemCount: survey.category.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Text("${(index + 1)} \t"),
                            Text(survey.category[index]),
                          ],
                        );
                      },
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RawMaterialButton(
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _editSurveyName(survey);
                          },
                          constraints: const BoxConstraints(
                            minWidth: 35.0,
                            minHeight: 35.0,
                          ),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          shape: CircleBorder(),
                        ),
                        RawMaterialButton(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _removeSurvey(survey);
                          },
                          constraints: const BoxConstraints(
                            minWidth: 35.0,
                            minHeight: 35.0,
                          ),
                          elevation: 2.0,
                          fillColor: Colors.white,
                          shape: CircleBorder(),
                        ),
                      ],
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
              : _surveys.isNotEmpty
                  ? showSurveys(context)
                  : Center(
                      child: Text('Geen surveys gevonden'),
                      //onPressed: _onAddRandomRecipesPressed,
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSurvey(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
