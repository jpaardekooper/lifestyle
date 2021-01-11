import 'package:cloud_firestore/cloud_firestore.dart';

class DtdAwnserModel {
  DtdAwnserModel({this.id, this.awnser, this.question, this.order})
      : reference = null;

  final String id;
  final String awnser;
  final String question;
  final int order;

  final DocumentReference reference;

  DtdAwnserModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        awnser = (snapshot.data()['awnser']).replaceAll(',', ', '),
        question = snapshot.data()['question'],
        order = snapshot.data()['order'],
        reference = snapshot.reference;
}
