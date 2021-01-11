import 'package:cloud_firestore/cloud_firestore.dart';

class DtdModel {
  DtdModel({this.id, this.date, this.fieldId}) : reference = null;

  final String id;
  final Timestamp date;
  final String fieldId;

  final DocumentReference reference;

  DtdModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        date = snapshot.data()['date'],
        fieldId = snapshot.data()['id'],
        reference = snapshot.reference;
}
