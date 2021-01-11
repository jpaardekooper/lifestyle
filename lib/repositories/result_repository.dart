import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/dtd_screening_model.dart';
import 'package:lifestylescreening/models/result_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';

import 'result_repository_interface.dart';

class ResultRepository implements IResultRepository {
  @override
  Stream<QuerySnapshot> streamResults() {
    return FirebaseFirestore.instance.collection('results').snapshots();
  }

  @override
  List<ResultModel> getResultList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return ResultModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Stream<QuerySnapshot> streamResultUsers(String surveyId) {
    return FirebaseFirestore.instance
        .collection('results')
        .doc(surveyId)
        .collection('scores')
        .snapshots();
  }

  @override
  List<DtdModel> getDtdUserList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return DtdModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  List<SurveyResultModel> getSurveyUserList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return SurveyResultModel.fromSnapshot(doc);
    }).toList();
  }
}
