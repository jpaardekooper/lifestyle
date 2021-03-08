import 'package:cloud_firestore/cloud_firestore.dart';

class DtdAwnserModel {
  DtdAwnserModel({this.id, this.answer, this.question, this.order})
      : reference = null;

  final String? id;
  final String? answer;
  final String? question;
  final int? order;

  final DocumentReference? reference;

  DtdAwnserModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        answer = snapshot.data()!['answer'],
        question = snapshot.data()!['question'],
        order = snapshot.data()!['order'],
        reference = snapshot.reference;
}
