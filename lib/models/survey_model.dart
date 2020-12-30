import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyModel {
  SurveyModel({this.id, this.category, this.title}) : reference = null;

  final String id;
  final String title;
  final List<String> category;

  final DocumentReference reference;

  SurveyModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        title = snapshot.data()['title'],
        category = List.from(snapshot.data()['category'] ?? []),
        reference = snapshot.reference;
}
