import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lifestylescreening/models/survey_model.dart';
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
}
