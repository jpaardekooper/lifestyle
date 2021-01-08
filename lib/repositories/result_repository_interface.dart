import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/result_model.dart';

abstract class IResultRepository {
  Stream<QuerySnapshot> streamResults();

  List<ResultModel> getResultList(QuerySnapshot snapshot);

  Stream<QuerySnapshot> streamResultUsers(String test);

  List<ResultModel> getResultUserList(QuerySnapshot snapshot);
}
