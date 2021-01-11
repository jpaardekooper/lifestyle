import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/dtd_answer_model.dart';
import 'package:lifestylescreening/models/dtd_screening_model.dart';
import 'package:lifestylescreening/models/result_model.dart';
import 'package:lifestylescreening/models/survery_answer_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';

abstract class IResultRepository {
  Stream<QuerySnapshot> streamResults();

  List<ResultModel> getResultList(QuerySnapshot snapshot);

  Stream<QuerySnapshot> streamResultUsers(String surveyId);

  List<DtdModel> getDtdUserList(QuerySnapshot snapshot);

  List<SurveyResultModel> getSurveyUserList(QuerySnapshot snapshot);

  Future<List<DtdAwnserModel>> getDtdAnswers(String dtdId);

  Future<List<SurveyAnswerModel>> getSurveyAnswers(
      String surveyId, String category);
}
