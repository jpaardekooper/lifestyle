import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyAnswerModel {
  SurveyAnswerModel(
      {this.id,
      this.answer,
      this.question,
      this.date,
      this.points,
      this.duration})
      : reference = null;

  final String? id;
  final List<String>? answer;
  final List<String>? question;
  final Timestamp? date;
  final int? points;
  final int? duration;

  final DocumentReference? reference;

  SurveyAnswerModel.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        answer = List.from(snapshot.data()!['answer']),
        question = List.from(snapshot.data()!['question']),
        date = snapshot.data()!['date'],
        points = snapshot.data()!['points'],
        duration = snapshot.data()!['duration'],
        reference = snapshot.reference;
}
