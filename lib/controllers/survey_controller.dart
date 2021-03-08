import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'package:lifestylescreening/repositories/survey_repository.dart';
import 'package:lifestylescreening/repositories/survey_repository_interface.dart';

class SurveyController {
  final ISurveyRepository _surveyRepository = SurveyRepository();

  Stream<QuerySnapshot> streamSurveys() {
    return _surveyRepository.streamSurveys();
  }

  List<SurveyModel> getSurveyList(QuerySnapshot snapshot) {
    return _surveyRepository.getSurveyList(snapshot);
  }

  Future<void> updateSurvey(String? id, Map data, bool? newItem) {
    return _surveyRepository.updateSurvey(id, data, newItem);
  }

  Future<void> removeSurvey(String? id) {
    return _surveyRepository.removeSurvey(id);
  }

  Future<void> removeCategory(String? id, String data) {
    return _surveyRepository.removeCategory(id, data);
  }

  Future<List<SurveyResultModel>> getLastSurveyResult(String? email) {
    return _surveyRepository.getLastSurveyResult(email);
  }
}
