import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/survey_model.dart';
import 'package:lifestylescreening/models/survey_result_model.dart';
import 'survey_repository_interface.dart';

class SurveyRepository implements ISurveyRepository {
  @override
  Stream<QuerySnapshot> streamSurveys() {
    return FirebaseFirestore.instance.collection('surveys').snapshots();
  }

  @override
  List<SurveyModel> getSurveyList(QuerySnapshot snapshot) {
    return snapshot.docs.map((DocumentSnapshot doc) {
      return SurveyModel.fromSnapshot(doc);
    }).toList();
  }

  @override
  Future<void> updateSurvey(String id, Map data, bool newItem) async {
    if (newItem) {
      await FirebaseFirestore.instance
          .collection("surveys")
          .doc()
          .set(data)
          .catchError((e) {});

      await FirebaseFirestore.instance
          .collection("results")
          .doc()
          .set(data)
          .catchError((e) {});
    } else {
      await FirebaseFirestore.instance
          .collection("surveys")
          .doc(id)
          .set(data)
          .catchError((e) {});
    }
  }

  @override
  Future<void> removeSurvey(String id) async {
    await FirebaseFirestore.instance
        .collection("surveys")
        .doc(id)
        .delete()
        .catchError((e) {});
  }

  @override
  Future<void> removeCategory(String id, String data) async {
    await FirebaseFirestore.instance.collection("surveys").doc(id).update({
      "category": FieldValue.arrayRemove([data])
    }).catchError((e) {});
  }

  @override
  Future<List<SurveyResultModel>> getLastSurveyResult(String email) async {
    List<SurveyResultModel> _list = [];

    var snapshot = await FirebaseFirestore.instance
        .collection("results")
        .doc("j4HGRmdE62VTRbtqYsvM")
        .collection("scores")
        .where("email", isEqualTo: email)
        .where("finished", isEqualTo: true)
        .get();

    snapshot.docs.map((DocumentSnapshot doc) {
      return _list.add(SurveyResultModel.fromSnapshot(doc));
    }).toList();

    _list.sort((a, b) => b.date.compareTo(a.date));

    return _list;
  }
}
