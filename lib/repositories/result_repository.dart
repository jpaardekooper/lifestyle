import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/result_model.dart';

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
  Stream<QuerySnapshot> streamResultUsers(String testId) {
    return FirebaseFirestore.instance
        .collection('results')
        .doc(testId)
        .collection('scores')
        .snapshots();
  }

  @override
  List<ResultModel> getResultUserList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return ResultModel.fromSnapshot(doc);
    }).toList();
  }
}
