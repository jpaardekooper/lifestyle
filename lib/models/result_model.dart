import 'package:cloud_firestore/cloud_firestore.dart';

class ResultModel {
  ResultModel({this.id, this.title}) : reference = null;

  final String id;
  final String title;

  final DocumentReference reference;

  ResultModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        title = snapshot.data()['title'],
        reference = snapshot.reference;
}
