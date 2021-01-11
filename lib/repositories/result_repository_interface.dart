import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/dtd_awnser_model.dart';
import 'package:lifestylescreening/models/dtd_screening_model.dart';
import 'package:lifestylescreening/models/result_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';

abstract class IResultRepository {
  Stream<QuerySnapshot> streamResults();

  List<ResultModel> getResultList(QuerySnapshot snapshot);

  Stream<QuerySnapshot> streamResultUsers(String surveyId);

  List<DtdModel> getDtdUserList(QuerySnapshot snapshot);

  List<SurveyResultModel> getSurveyUserList(QuerySnapshot snapshot);

  Future<List<DtdAwnserModel>> getDtdAwnsers(String dtdId);
}
