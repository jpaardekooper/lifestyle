import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';

abstract class ISurveyRepository {
  Stream<QuerySnapshot> streamSurveys();

  List<SurveyModel> getSurveyList(QuerySnapshot snapshot);

  Future<void> updateSurvey(String? id, Map data, bool? newItem);

  Future<void> removeSurvey(String? id);

  Future<void> removeCategory(String? id, String data);

  Future<List<SurveyResultModel>> getLastSurveyResult(String? email);
}
