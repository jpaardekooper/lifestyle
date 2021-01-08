import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/result_model.dart';
import 'package:lifestylescreening/repositories/result_repository.dart';
import 'package:lifestylescreening/repositories/result_repository_interface.dart';

class ResultController {
  final IResultRepository _resultRepository = ResultRepository();

  Stream<QuerySnapshot> streamResults() {
    return _resultRepository.streamResults();
  }

  List<ResultModel> getResultList(QuerySnapshot snapshot) {
    return _resultRepository.getResultList(snapshot);
  }
}
