import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyResultModel {
  SurveyResultModel(
      {this.id,
      this.email,
      this.index,
      this.category,
      this.categories,
      this.points_per_category,
      this.total_points,
      this.total_duration,
      this.finished,
      this.date})
      : reference = null;

  final String? id;
  final String? email;
  final int? index;
  final String? category;
  final List<String>? categories;
  final List<int>? points_per_category;
  final int? total_points;
  final int? total_duration;
  final bool? finished;
  final Timestamp? date;
  final DocumentReference? reference;

  SurveyResultModel.fromSnapshot(DocumentSnapshot snapshot)
      : assert(snapshot != null),
        id = snapshot.id,
        email = snapshot.data()!['email'],
        index = snapshot.data()!['index'],
        category = snapshot.data()!['category'],
        categories = List.from(snapshot.data()!['categories'] ?? []),
        points_per_category =
            List.from(snapshot.data()!['points_per_category'] ?? []),
        total_points = snapshot.data()!['total_points'],
        total_duration = snapshot.data()!['total_duration'],
        finished = snapshot.data()!['finished'],
        date = snapshot.data()!['date'],
        reference = snapshot.reference;
}
